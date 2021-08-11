require "rails_helper"

RSpec.describe DummyMailer, type: :mailer do
  it "parses the tags" do
    mail = described_class.with_tags
    expect(mail.tags).to eq ["hello_world"]
  end

  it "supports multiple tags" do
    mail = described_class.with_tags(["hello", "world"])
    expect(mail.tags).to eq ["hello", "world"]
  end

  it "doesn't break with no tags at all" do
    mail = described_class.no_tags
    expect(mail.tags).to be_nil
  end
end
