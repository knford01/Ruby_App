require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module RubyApp
  class Application < Rails::Application
    # Set the Rails version default
    config.load_defaults 8.0
    
    # Autoload only specific files (this is optional, depending on your use case)
    config.autoload_lib(ignore: %w[assets tasks])

    # Set the environment variable for SSL certificate (make sure the path is correct)
    ENV["SSL_CERT_FILE"] = "C:/Ruby34-x64/ssl/cacert.pem"
  end
end
