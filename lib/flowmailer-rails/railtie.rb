module FlowmailerRails
  class Railtie < Rails::Railtie
    initializer "flowmailer-rails", before: "action_mailer.set_configs" do
      ActiveSupport.on_load :action_mailer do
        FlowmailerRails.install
      end
    end
  end
end
