require "rails_helper"

RSpec.describe DefaultsMailer, type: :mailer do
  it "supports default values" do
    mail = described_class.mail_with_defaults
    expect(mail.tags).to eq ["default_tag"]
  end
end
