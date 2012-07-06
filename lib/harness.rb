require "harness/version"

require 'redis'
require 'redis/namespace'

require 'active_support/notifications'
require 'active_support/core_ext/string'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/numeric'
require 'active_support/core_ext/integer'

require 'active_support/ordered_options'

module Harness
  class LoggingError < RuntimeError ; end
  class NoCounter < RuntimeError ; end

  class Config
    attr_reader :adapter, :queue
    attr_accessor :namespace
    attr_reader :instrument

    def initialize
      @instrument = ActiveSupport::OrderedOptions.new
    end

    def adapter=(val)
      if val.is_a? Symbol
        @adapter = "Harness::#{val.to_s.camelize}Adapter".constantize.new
      else
        @adapter = val
      end
    end

    def queue=(val)
      if val.is_a? Symbol
        @queue = "Harness::#{val.to_s.camelize}Queue".constantize.new
      else
        @queue = val
      end
    end

    def method_missing(name, *args, &block)
      begin
        "Harness::#{name.to_s.camelize}Adapter".constantize.config
      rescue NameError
        super
      end
    end
  end

  def self.config
    @config ||= Config.new
  end

  def self.log(measurement)
    config.queue.push measurement
  end

  def self.logger
    @logger
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.redis=(redis)
    @redis = redis
  end

  def self.redis
    @redis
  end

  def self.reset_counters!
    redis.smembers('counters').each do |counter|
      redis.set counter, 0
      redis.del "meters/#{counter}"
    end
  end
end

require 'harness/measurement'
require 'harness/counter'
require 'harness/gauge'
require 'harness/meter'

require 'harness/instrumentation'

require 'harness/job'

require 'harness/queues/synchronous_queue'

require 'harness/adapters/librato_adapter'
require 'harness/adapters/memory_adapter'
require 'harness/adapters/null_adapter'
require 'harness/adapters/statsd_adapter'

require 'harness/railtie' if defined?(Rails)

require 'logger'

Harness.logger = Logger.new $stdout
