module Harness
  class Railtie < ::Rails::Railtie
    config.harness = Harness.config

    rake_tasks do
      load "harness/tasks.rake"
    end

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

    initializer "harness.redis" do 
      if existing_url = ENV['REDISTOGO_URL'] || ENV['REDIS_URL']
        Harness.redis ||= Redis::Namespace.new('harness', :redis => Redis.connect(:url => existing_url))
      else
        Harness.redis ||= Redis::Namespace.new('harness', :redis => Redis.connect(:host => 'localhost', :port => '6379'))
      end
    end
  end
end
