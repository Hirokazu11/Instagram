require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module InstaApp
  class Application < Rails::Application
    config.load_defaults 5.2
    config.assets.initialize_on_precompile = false
    config.generators do |g|
      g.javascripts false
      g.stylesheets false
      g.test_framework :rspec,
      view_specs: false,
      helper_specs: false,
      routing_specs: false,
      controller_specs: false
    end
  end
end
