class DefaultsMailer < ApplicationMailer
  default tags: ["default_tag"]

  def mail_with_defaults
    mail(
      to: "john.doe@example.com",
      subject: "hello world",
      body: "hejhej"
    )
  end

  def mail_with_merge
    mail(
      to: "john.doe@example.com",
      subject: "hello world",
      body: "hejhej",
      tags: ["new_tag"]
    )
  end
end
