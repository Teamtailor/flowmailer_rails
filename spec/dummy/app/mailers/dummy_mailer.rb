class DummyMailer < ApplicationMailer
  def hello_world(tags = ["hello_world"])
    mail(
      to: "john.doe@example.com",
      subject: "hello world",
      body: "hejhej",
      tags: tags
    )
  end
end
