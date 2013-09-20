module Harness
  class Railtie < ::Rails::Railtie
    config.harness = Harness.config

    # Set default instrumentation
    config.harness.instrument.action_controller = true
    config.harness.instrument.action_mailer = true
    config.harness.instrument.action_view = true

    config.harness.instrument.active_support = false

    # Custom instrumentation can be turned on as follows
    # See files in lib/harness/integration for available integrations
    #
    # config.harness.instrument.sidekiq = true
    # config.harness.instrument.active_model_serializers = true

    initializer "harness.instrumentation" do |app|
      app.config.harness.instrument.each_pair do |integration, value|
        require "harness/integration/#{integration}" if value
      end
    end
  end
end
