UtteKatte::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => 'www.dejisute.com',
    :user_name            => 'no-reply@dejisute.com',
    :password             => 'changeme1337',
    :authentication       => 'plain',
    :enable_starttls_auto => true 
  }
  


  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true



end


STRIPE_SECRET_KEY="cGgQ93bT2W4vMnkHHNRKuF3OSNy8braH"
STRIPE_PUBLISHABLE_KEY="pk_L2f7EpVbOnwcb9vCQEDeDiXcuF5FH"

Stripe.api_key = STRIPE_SECRET_KEY

AWS_BUCKET = "dejisuteuploadsdev"
AWS_UPLOAD_DIR = "files"


TWITTER_CONSUMER_KEY = "njvaqvy2Ab6syd3SELcZJw"
TWITTER_CONSUMER_SECRET = "NFQzV0zq5JrIJ5ofRbKYUFWE7oG3g0fm6dQTUMq7bE"

FACEBOOK_KEY = "192133417590588"
FACEBOOK_SECRET = "c3cd8859fd59549b959c5982ecd41b4d"

SOUNDCLOUD_KEY = "1ecd2693d5559e8e58524ddadc796dfd"
SOUNDCLOUD_SECRET = "74405697acf4fc80238ff088741aa0ff"

GOOGLE_KEY = "94253598057.apps.googleusercontent.com"
GOOGLE_SECRET = "smelUHEdT52TchWqS5zw90p3"
