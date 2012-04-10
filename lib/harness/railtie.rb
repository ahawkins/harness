module Harness
  class Railtie < ::Rails::Railtie
    config.harness = Harness.config

    initializer "harness.thread" do
      Thread.abort_on_exception = Rails.env.development? || Rails.env.test?
    end

    initializer "harness.adapter" do |app|
      case Rails.env
      when 'development'
        app.config.harness.adapter = :null
      when 'test'
        app.config.harness.adapter = :null
      else
        app.config.harness.adapter = :librato
      end
    end

    initializer "harness.logger" do |app|
      Harness.logger = Rails.logger
    end
  end
end
