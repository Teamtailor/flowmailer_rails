RSpec.describe FlowmailerRails::Mailer do
  let(:subject) { described_class.new(account_id: 1337, client_id: "client-123", client_secret: "secret-123" ) }
  let(:response_double) { double(:response, "success?" => true, status: 201, body: "", headers: {"location" => "foo/123xyz"}) }

  describe "#deliver!" do
    context "with valid access_token" do
      before {
        stub_access_token
        stub_submit_message
      }

      it "submits the mail to the Flowmailer api" do
        mail = Mail.new(to: "john@example.com")
        subject.deliver!(mail)
        expect(a_request(:post, "https://api.flowmailer.net/1337/messages/submit").
          with { |req|
            expect(JSON.parse(req.body)).to include_json(recipientAddress: "john@example.com")
            req.headers["Authorization"] == "Bearer abc123"
        }).to have_been_made.once
      end

      it "makes a api request for each recipient" do
        mail = Mail.new(to: "test@example.com; foo@example.com")
        expect(subject).to receive(:submit_message) { |path, body, headers|
          expect(JSON.parse(body)).to include_json(recipientAddress: "test@example.com")
        }.and_return(response_double)

        expect(subject).to receive(:submit_message) { |path, body, headers|
          expect(JSON.parse(body)).to include_json(recipientAddress: "foo@example.com")
        }.and_return(response_double)

        subject.deliver!(mail)
      end
    end

    context "when no valid access_token" do
      it "raises an error" do
        stub_access_token(status: 403)

        mail = Mail.new(to: "test@example.com; foo@example.com")

        expect {
          subject.deliver!(mail)
        }.to raise_error(FlowmailerRails::Mailer::NoAccessTokenError)
      end
    end
  end
end
