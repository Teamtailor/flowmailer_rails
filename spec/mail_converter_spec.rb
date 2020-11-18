RSpec.describe FlowmailerRails::MailConverter do
  let(:default_mail) {
    Mail.new(
      to: "john.doe@example.com",
      from: "no-reply@example.com",
      message_id: "1337",
      date: Time.parse("2010-01-01T12:00:00+00:00").utc
    )
  }
  let(:subject) { described_class.new(mail) }

  describe "#recipients_as_json" do
    context "with one recipient" do
      let(:mail) { default_mail }
      it "returns a json object for that recipient" do
        result = subject.recipients_as_json
        json = JSON.parse(result.first)
        expect(result.size).to eq(1)
        expect(json).to include_json(
          messageType: "EMAIL",
          senderAddress: "no-reply@example.com",
          recipientAddress: "john.doe@example.com",
          mimedata: "RGF0ZTogRnJpLCAwMSBKYW4gMjAxMCAxMjowMDowMCArMDAwMA0KRnJvbTog\nbm8tcmVwbHlAZXhhbXBsZS5jb20NClRvOiBqb2huLmRvZUBleGFtcGxlLmNv\nbQ0KTWVzc2FnZS1JRDogMTMzNw0KTWltZS1WZXJzaW9uOiAxLjANCkNvbnRl\nbnQtVHlwZTogdGV4dC9wbGFpbg0KQ29udGVudC1UcmFuc2Zlci1FbmNvZGlu\nZzogN2JpdA0KDQo=\n"
        )
      end
    end

    context "with multiple recipient" do
      let(:mail) { default_mail.tap {|m| m.to = "John Doe <john@example.com>; Jane Doe <jane@example.com>" } }

      it "returns a json object for that recipient" do
        result = subject.recipients_as_json
        json1 = JSON.parse(result.first)
        json2 = JSON.parse(result.second)
        expect(result.size).to eq(2)
        expect(json1).to include_json(
          recipientAddress: "john@example.com",
        )
        expect(json2).to include_json(
          recipientAddress: "jane@example.com",
        )
      end
    end
  end
end
