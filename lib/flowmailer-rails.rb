require 'action_mailer'
require 'flowmailer-rails/mailer'
require 'flowmailer-rails/mail_converter'

module FlowmailerRails
  def self.install
    ActionMailer::Base.add_delivery_method :flowmailer, FlowmailerRails::Mailer
  end
end

if defined?(Rails)
  require 'flowmailer-rails/railtie'
else
  FlowmailerRails.install
end
