# Settings specified here will take precedence over those in config/environment.rb

$willustrator_config = {
  :hatena_api_key => 'f7be328d4e368d3156bf0f7b5da308bd',
  :hatena_api_secret => 'e159f70bbadda3fc',
  :offline => false
}

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors if you bad email addresses should just be ignored
# config.action_mailer.raise_delivery_errors = false