require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MreliefScaffold
  class Application < Rails::Application

    config.action_dispatch.default_headers = {
        'X-Frame-Options' => 'ALLOWALL'
    }

    config.serve_static_assets = true

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :authentication => :plain,
      :address => "smtp.mailgun.org",
      :port => 587,
      :domain => "mrelief.mailgun.com",
      :user_name => "postmaster@mrelief.mailgun.org",
      :password => ENV["mailgun_password"]
    }


    config.i18n.enforce_available_locales = false
  end
end
