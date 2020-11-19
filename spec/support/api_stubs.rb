module ApiStubs
  DEFAULT_TOKEN = "abc123"

  def stub_access_token(token: DEFAULT_TOKEN, status: 201)
    stub_request(:post, "https://login.flowmailer.net/oauth/token")
      .with(
        body: {"client_id" => "client-123", "client_secret" => "secret-123", "grant_type" => "client_credentials", "scope" => "api"}
      )
      .to_return(status: status, body: {access_token: token}.to_json, headers: {"Content-type": "application/json"})
  end

  def stub_access_tokens(tokens: [], status: 201)
    request_stub = stub_request(:post, "https://login.flowmailer.net/oauth/token")
      .with(
        body: {"client_id" => "client-123", "client_secret" => "secret-123", "grant_type" => "client_credentials", "scope" => "api"}
      )
    tokens.each do |token|
      request_stub.to_return(status: status, body: {access_token: token}.to_json, headers: {"Content-type": "application/json"})
    end
  end

  def stub_submit_message(message_id: "message-123123", status: 201, token: DEFAULT_TOKEN)
    stub_request(:post, "https://api.flowmailer.net/1337/messages/submit").with(headers: {Authorization: "Bearer #{token}"})
      .to_return(status: status, body: "", headers: {location: "https://api.flowmailer.net/1337/messages/#{message_id}"})
  end
end
