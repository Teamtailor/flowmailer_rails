RSpec.describe FlowmailerRails::Mailer do
  let(:subject) { described_class.new(account_id: 1337, client_id: "client-123", client_secret: "secret-123") }
  let(:response_double) { double(:response, "success?" => true, :status => 201, :body => "", :headers => {"location" => "foo/123xyz"}) }

  describe "#deliver!" do
    context "with procs for access tokens" do
      let(:subject) {
        described_class.new(
          account_id: 1337,
          access_token: -> { ENV["FAKE_GLOBAL_ACCESS_TOKEN"] ||= "proc-access-token" },
          fetch_new_access_token: -> { ENV["FAKE_GLOBAL_ACCESS_TOKEN"] = "newproc-access-token" }
        )
      }

      it "fetches access token from the proc" do
        stub_submit_message(token: "proc-access-token")

        mail = Mail.new(to: "john@example.com")
        subject.deliver!(mail)

        expect(
          a_request(:post, "https://api.flowmailer.net/1337/messages/submit")
          .with { |req|
            req.headers["Authorization"] == "Bearer proc-access-token"
          }
        ).to have_been_made.once
      end

      it "fetches new access token from the proc" do
        stub_submit_message(token: "proc-access-token", status: 401)
        stub_submit_message(token: "newproc-access-token")

        mail = Mail.new(to: "john@example.com")
        subject.deliver!(mail)

        expect(
          a_request(:post, "https://api.flowmailer.net/1337/messages/submit")
          .with { |req|
            req.headers["Authorization"] == "Bearer newproc-access-token"
          }
        ).to have_been_made.once
      end
    end

    context "with valid access_token" do
      before do
        stub_access_token
        stub_submit_message
      end

      it "submits the mail to the Flowmailer api" do
        mail = Mail.new(to: "john@example.com")
        subject.deliver!(mail)
        expect(
          a_request(:post, "https://api.flowmailer.net/1337/messages/submit")
          .with { |req|
            expect(JSON.parse(req.body)).to include_json(recipientAddress: "john@example.com")
            req.headers["Authorization"] == "Bearer abc123"
          }
        ).to have_been_made.once
      end

      it "makes a api request for each recipient" do
        mail = Mail.new(to: "test@example.com; foo@example.com")
        expect(subject).to receive(:submit_message) { |json|
          expect(JSON.parse(json)).to include_json(recipientAddress: "test@example.com")
        }.and_return(response_double)

        expect(subject).to receive(:submit_message) { |json|
          expect(JSON.parse(json)).to include_json(recipientAddress: "foo@example.com")
        }.and_return(response_double)

        subject.deliver!(mail)
      end
    end

    context "with expired access_token" do
      it "fetches a new token" do
        stub_access_tokens(tokens: ["first-token", "second-token"])
        stub_submit_message(status: 401, token: "first-token")
        stub_submit_message(token: "second-token")

        mail = Mail.new(to: "test@example.com")
        subject.deliver!(mail)
      end

      it "retries 4 times before rasing an exception" do
        stub_access_tokens(tokens: ["first-token", "second-token", "third-token", "forth-token"])
        stub_submit_message(status: 401, token: "first-token")
        stub_submit_message(status: 401, token: "second-token")
        stub_submit_message(status: 401, token: "third-token")
        stub_submit_message(status: 401, token: "forth-token")

        mail = Mail.new(to: "test@example.com")
        expect {
          subject.deliver!(mail)
        }.to raise_error(FlowmailerRails::Mailer::ExpiredAccessTokenError)
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

    context "with unsuccessful response" do
      before do
        stub_access_token
        stub_request(:post, "https://api.flowmailer.net/1337/messages/submit")
          .to_return(status: 420, body: "")
      end

      it "raises DeliveryError" do
        mail = Mail.new(to: "john@example.com")

        expect { subject.deliver!(mail) }.to raise_error(FlowmailerRails::Mailer::DeliveryError)
      end
    end

    context "with too big message" do
      let(:mailer) { described_class.new(account_id: 1337, client_id: "client-123", client_secret: "secret-123") }

      before do
        stub_access_token
        response_body = {allErrors: [{code: "message.toobig", defaultMessage: "Message too big 10658211 > 10485760"}]}
        stub_request(:post, "https://api.flowmailer.net/1337/messages/submit")
          .to_return(status: 422, body: response_body.to_json, headers: {"Content-type": "application/json"})
      end

      it "raises TooBigMessageError" do
        mail = Mail.new(to: "john@example.com")

        expect { mailer.deliver!(mail) }.to raise_error(FlowmailerRails::Mailer::TooBigMessageError)
      end
    end
  end
end
