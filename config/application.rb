require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MreliefScaffold
  class Application < Rails::Application
    config.serve_static_assets = true

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => "smtp.gmail.com",
      :user_name            => ENV["user_name"],
      :password             => ENV["password"],
      :authentication       => :plain,
      :enable_starttls_auto => true
    }

    config.action_mailer.default_url_options = {
      :host => "mreliefv2.herokuapp.com"
    }

  end
end
