require "json"

module FlowmailerRails
  class MailConverter
    attr_reader :rails_mail

    def initialize(rails_mail)
      @rails_mail = rails_mail
    end

    def recipients_as_json
      recipient_addresses.map do |recipient|
        JSON.dump(as_json.merge(recipientAddress: recipient))
      end
    end

    private

    def as_json
      @json ||= {
        messageType: "EMAIL",
        mimedata: mimedata,
        senderAddress: sender_address
      }
    end

    def mimedata
      Base64.encode64(rails_mail.to_s)
    end

    def sender_address
      Mail::Address.new(
        rails_mail.from_addrs.first
      ).address
    end

    def recipient_addresses
      (rails_mail.to_addrs | rails_mail.cc_addrs | rails_mail.bcc_addrs).map do |address|
        Mail::Address.new(address).address
      end
    end
  end
end
