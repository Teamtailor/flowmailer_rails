require "action_mailer"
require "flowmailer_rails/mailer"
require "flowmailer_rails/mail_converter"
require "flowmailer_rails/message_extensions/mail"

module FlowmailerRails
  def self.install
    ActionMailer::Base.add_delivery_method :flowmailer, FlowmailerRails::Mailer
  end
end

# :nocov:
if defined?(Rails)
  require "flowmailer_rails/railtie"
else
  FlowmailerRails.install
end
# :nocov:
