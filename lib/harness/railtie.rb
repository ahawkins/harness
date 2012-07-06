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

    rake_tasks do
      load "harness/tasks.rake"
    end

    initializer "harness.adapter" do |app|
      app.config.harness.adapter ||= case Rails.env
                                     when 'development' then :null
                                     when 'test' then :null
                                     else :librato
                                     end
    end

    initializer "harness.logger" do |app|
      Harness.logger = Rails.logger
    end

    initializer "harness.redis" do
      if existing_url = ENV['REDISTOGO_URL'] || ENV['REDIS_URL']
        Harness.redis ||= Redis::Namespace.new('harness', :redis => Redis.connect(:url => existing_url))
      else
        Harness.redis ||= Redis::Namespace.new('harness', :redis => Redis.connect(:host => 'localhost', :port => '6379'))
      end
    end

    initializer "harness.queue" do
      Harness.config.queue = :synchronous
    end

    initializer "harness.queue.production" do |app|
      use_real_queue = Rails.env != 'development' && Rails.env != 'test'

      if defined?(Resque::Job) && use_real_queue
        require 'harness/queues/resque_queue'
        Harness.config.queue = :resque
      elsif defined?(Sidekiq::Worker) && use_real_queue
        require 'harness/queues/sidekiq_queue'
        Harness.config.queue = :sidekiq
      end
    end

    initializer "harness.instrumentation" do |app|
      app.config.harness.instrument.each_pair do |integration, value|
        require "harness/integration/#{integration}" if value
      end
    end
  end
end
