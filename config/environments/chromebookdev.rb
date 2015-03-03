Reprobus::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug
  
  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.

# ActionMailer Config
config.action_mailer.default_url_options = { :host => 'firstapp-rails-86540.apse2.nitrousbox.com' }
config.action_mailer.delivery_method = :smtp
# change to true to allow email to be sent during development
config.action_mailer.perform_deliveries = false
config.action_mailer.raise_delivery_errors = false
config.action_mailer.default :charset => "utf-8"

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  Rails.application.routes.default_url_options[:host] = 'http://firstapp-rails-86540.apse2.nitrousbox.com' # used for payment express success and failure link generation
  
end
