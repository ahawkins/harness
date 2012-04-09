module Harness
  class Railtie < ::Rails::Railtie
    config.harness = Harness.config

    initializer "harness.thread" do
      Thread.abort_on_exception = Rails.env.development?
    end

    initializer "harness.enabled" do |app|
      app.config.harness.enabled = true
    end

    initializer "harness.test_mode" do
      config.harness.enabled = false if Rails.env.test?
    end

    initializer "harness.adapter" do |app|
      case Rails.env
      when 'development'
        app.config.harness.adapter = :null
      else
        app.config.harness.adapter = :librato
      end
    end
  end
end
