require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MreliefScaffold
  class Application < Rails::Application

    config.action_mailer.smtp_settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => ENV["GMAIL_DOMAIN"],
      :user_name            => ENV["GMAIL_USERNAME"],
      :password             => ENV["GMAIL_PASSWORD"],
      :authentication       => :plain,
      :enable_starttls_auto => true
    }

    config.action_mailer.default_url_options = {
      :host => "http://localhost:3000/"
    }

  end
end
