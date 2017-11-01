Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    authentication: 'plain', 
    address:        "smtp.mailgun.org",
    port:           587,
    domain:         "sandboxdc75c5d333854d23b783d7fbbce1bb80.mailgun.org",
    user_name:      "postmaster@sandboxdc75c5d333854d23b783d7fbbce1bb80.mailgun.org",
    password:       "47d1f389db9269607c655c5c7cfbccc3"
  }

  config.paperclip_defaults = {
    storage:        :s3,
    path:           ':class/:attachment/:id/:style/:filename',
    s3_host_name:   's3-us-east-2.amazonaws.com',
    s3_credentials: {
      bucket: 'shed2017',
      access_key_id: 'AKIAIB544CKBAVQETDIA',
      secret_access_key: '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',
      s3_region: 'us-east-2'
    }
  }

  config.generators.assets = false
end
