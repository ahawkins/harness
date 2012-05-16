module Harness
  class Railtie < ::Rails::Railtie
    config.harness = Harness.config

    rake_tasks do
      load "harness/tasks.rake"
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

    initializer "harness.redis" do 
      if existing_url = ENV['REDISTOGO_URL'] || ENV['REDIS_URL']
        Harness.redis ||= Redis::Namespace.new('harness', :redis => Redis.connect(:url => existing_url))
      else
        Harness.redis ||= Redis::Namespace.new('harness', :redis => Redis.connect(:host => 'localhost', :port => '6379'))
      end
    end

    initializer "harness.queue" do
      Harness.config.queue = Harness::SyncronousQueue
    end

    initializer "harness.queue.production" do |app|
      use_real_queue = Rails.env != 'development' && Rails.env != 'test'

      if defined?(Resque) && use_real_queue
        require 'harness/queues/resque_queue'
        Harness.config.queue = :resque
      elsif defined?(Sidekiq) && use_real_queue
        require 'harness/queues/sidekiq_queue'
        Harness.config.queue = :sidekiq
      end
    end

    initializer "harness.sidekiq" do |app|
      if defined? Sidekiq
        require 'harness/integration/sidekiq'
      end
    end
  end
end
