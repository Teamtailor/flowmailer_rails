require "faraday"
require "faraday_middleware"

module FlowmailerRails
  class Mailer
    class NoAccessTokenError < StandardError; end
    class DeliveryError < StandardError; end
    class TooBigMessageError < DeliveryError; end
    class ExpiredAccessTokenError < StandardError; end

    OAUTH_ENDPOINT = "https://login.flowmailer.net".freeze
    API_ENDPOINT = "https://api.flowmailer.net".freeze

    attr_accessor :settings

    def initialize(values)
      self.settings = {}.merge!(values)
    end

    def deliver!(rails_mail)
      MailConverter.new(rails_mail).recipients_as_json.each do |json|
        response = submit_message(json)
        rails_mail.message_id = response.headers["location"].split("/").last
      end
    end

    private

    def path
      "#{settings[:account_id]}/messages/submit"
    end

    def authorization_header
      {Authorization: "Bearer #{access_token}"}
    end

    def submit_message(json)
      retries = 0
      begin
        response = api_client.post(path, json, authorization_header)

        handle_failure(response) unless response.success? && response.status < 400
      rescue ExpiredAccessTokenError
        if (retries += 1) <= 3
          fetch_new_access_token
          retry
        else
          raise
        end
      end

      response
    end

    def handle_failure(response)
      raise ExpiredAccessTokenError if response.status == 401

      too_big_error = response.body["allErrors"]&.find { |error| error["code"] == "message.toobig" }
      raise TooBigMessageError, too_big_error["defaultMessage"] if too_big_error.present?

      raise DeliveryError, response.body
    end

    def api_client
      @api_client ||= Faraday.new(url: API_ENDPOINT) { |conn|
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
      }
    end

    def access_token
      if settings[:access_token]
        settings[:access_token].call
      else
        @access_token ||= fetch_new_access_token
      end
    end

    def fetch_new_access_token
      if settings[:fetch_new_access_token]
        settings[:fetch_new_access_token].call
      else
        response = oauth_client.post(
          "oauth/token",
          client_id: settings[:client_id],
          client_secret: settings[:client_secret],
          grant_type: "client_credentials",
          scope: "api"
        )
        if response.success?
          @access_token = response.body["access_token"]
        else
          raise NoAccessTokenError, response.body
        end
      end
    end

    def oauth_client
      @oauth_client ||= Faraday.new(url: OAUTH_ENDPOINT) { |conn|
        conn.request :url_encoded
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
      }
    end
  end
end
