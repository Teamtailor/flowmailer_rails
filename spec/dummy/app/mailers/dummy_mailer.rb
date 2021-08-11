class DummyMailer < ApplicationMailer
  def with_tags(tags = ["hello_world"])
    mail(
      to: "john.doe@example.com",
      subject: "hello world",
      body: "hejhej",
      tags: tags
    )
  end

  def no_tags
    mail(
      to: "john.doe@example.com",
      subject: "hello world",
      body: "hejhej"
    )
  end
end
