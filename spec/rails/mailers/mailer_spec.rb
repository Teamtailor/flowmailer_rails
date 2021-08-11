require "rails_helper"

RSpec.describe DummyMailer, type: :mailer do
  it "parses the tags" do
    mail = described_class.hello_world
    expect(mail.tags).to eq ["hello_world"]
  end

  it "supports multiple tags" do
    mail = described_class.hello_world(["hello", "world"])
    expect(mail.tags).to eq ["hello", "world"]
  end
end
