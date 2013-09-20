require "harness/version"

require 'statsd'

require 'active_support/notifications'

require 'active_support/core_ext/string'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/numeric'
require 'active_support/core_ext/integer'

require 'active_support/ordered_options'

module Harness
  class Config
    attr_accessor :collector, :queue
    attr_reader :instrument

    def initialize
      @instrument = ActiveSupport::OrderedOptions.new
    end
  end

  Measurement = Struct.new(:name, :value, :rate) do
    def self.from_event(event)
      payload = event.payload
      value = payload.fetch name.split('::').last.downcase.to_sym

      case value
      when true
        new event.name
      when Fixnum
        new event.name, value
      when String
        new value
      when Hash
        new(value[:name] || event.name, value[:value], value[:rate])
      end
    end

    def sample_rate
      rate.nil? ? 1 : rate
    end
  end

  class Timer < Measurement
    def self.from_event(event)
      timer = super
      timer.value = event.duration
      timer
    end

    def ms
      value
    end

    def log
      Harness.timing name, ms, sample_rate
    end
  end

  class Counter < Measurement
    def log
      if value.nil?
        Harness.increment name, sample_rate
      else
        Harness.count name, value, sample_rate
      end
    end
  end

  def self.config
    @config ||= Config.new
  end

  def self.increment(*args)
    queue.push [:increment, args]
  end

  def self.decrement(*args)
    queue.push [:decrement, args]
  end

  def self.timing(*args)
    queue.push [:timing, args]
  end

  def self.count(*args)
    queue.push [:count, args]
  end

  def self.time(stat, sample_rate = 1)
    start = Time.now
    result = yield
    timing(stat, ((Time.now - start) * 1000).round, sample_rate)
    result
  end

  def self.instrument(name, sample_rate = 1, &block)
    result = time name, sample_rate, &block
    increment name, sample_rate
    result
  end

  def self.gauge(*args)
    queue.push [:gauge, args]
  end

  def self.queue
    config.queue
  end

  def self.collector
    config.collector
  end
end

require 'harness/synchronous_queue'
require 'harness/threaded_queue'

require 'harness/null_collector'

require 'harness/instrumentation'
require 'harness/subscription'

require 'harness/gauges/redis_gauge'
require 'harness/gauges/sidekiq_gauge'
require 'harness/gauges/memcached_gauge'

require 'harness/integration/rack_instrumenter'

require 'harness/railtie' if defined?(Rails)

Harness.config.queue = Harness::ThreadedQueue.new
