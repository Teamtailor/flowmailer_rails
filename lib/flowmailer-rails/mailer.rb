module FlowmailerRails
  class Mailer
    class NoAccessTokenError < StandardError; end
    class DeliveryError < StandardError; end

    OAUTH_ENDPOINT = "https://login.flowmailer.net"
    API_ENDPOINT = "https://api.flowmailer.net"

    attr_accessor :settings

    def initialize(values)
      self.settings = {}.merge!(values)
    end

    def deliver!(rails_mail)
      MailConverter.new(rails_mail).recipients_as_json.each do |json|
        puts "**** hej 1"
        response = api_client.post(path, json, authorization_header)
        puts "**** hej 2"
        puts response.status
        puts response.body
        puts "**** hej 3"
        raise DeliveryError.new(response.body) unless response.success?
      end
    end

    private

    def path
      "#{settings[:account_id]}/messages/submit"
    end

    def authorization_header
      {Authorization: "Bearer #{access_token}"}
    end

    def api_client
      @api_client ||= Faraday.new(url: API_ENDPOINT) do |conn|
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
      end
    end

    def access_token
      response = oauth_client.post(
        "oauth/token",
        client_id: settings[:client_id],
        client_secret: settings[:client_secret],
        grant_type: "client_credentials",
        scope: "api",
      )
      if response.success?
        return response.body["access_token"]
      else
        raise NoAccessTokenError.new(response.body)
      end
    end

    def oauth_client
      @oauth_client ||= Faraday.new(url: OAUTH_ENDPOINT) do |conn|
        conn.request :url_encoded
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
