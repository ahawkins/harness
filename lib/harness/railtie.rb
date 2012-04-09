module Harness
  class Railtie < ::Rails::Railtie
    config.harness = Harnes.config

    initializer "harness.test_mode" do
      config.harness.test_mode = Rails.env.test?
    end

    initializer "harness.thread" do
      Thread.abort_on_exception = Rails.env.test? || Rails.env.development?
    end
  end
end
