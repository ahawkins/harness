module Harness
  class Railtie < ::Rails::Railtie
    config.harness = Harness.config

    initializer "harness.test_mode" do
      config.harness.test_mode = Rails.env.test?
    end

    initializer "harness.thread" do
      Thread.abort_on_exception = Rails.env.test? || Rails.env.development?
    end

    initializer "harness.adapter" do |app|
      app.config.harness.adapter = :null
    end
  end
end
