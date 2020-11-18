module ApiStubs
  def stub_access_token(token: "abc123", status: 201)
    stub_request(:post, "https://login.flowmailer.net/oauth/token").
      with(
        body: {"client_id"=>"client-123", "client_secret"=>"secret-123", "grant_type"=>"client_credentials", "scope"=>"api"}
      ).
      to_return(status: status, body: {access_token: token}.to_json, headers: {"Content-type": "application/json"})
  end

  def stub_submit_message(message_id: "message-123123")
    stub_request(:post, "https://api.flowmailer.net/1337/messages/submit").
      to_return(status: 200, body: "", headers: {location: "https://api.flowmailer.net/1337/messages/#{message_id}"})
  end
end
