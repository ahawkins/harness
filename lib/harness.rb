require "harness/version"

require 'active_support/notifications'
require 'active_support/core_ext/string'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/numeric'
require 'active_support/core_ext/integer'

require 'active_support/ordered_options'

module Harness
  class Config
    attr_accessor :statsd
    attr_accessor :source
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
      Harness.config.statsd.timing name, ms, sample_rate
    end
  end

  class Counter < Measurement
    def log
      if value.nil?
        Harness.config.statsd.increment name, sample_rate
      else
        Harness.config.statsd.count name, value, sample_rate
      end
    end
  end

  def self.config
    @config ||= Config.new
  end
end

require 'harness/instrumentation'
require 'harness/instrumenters/redis_instrumenter'
require 'harness/instrumenters/sidekiq_instrumenter'
require 'harness/instrumenters/memcached_instrumenter'
require 'harness/instrumenters/rack_instrumenter'

require 'harness/railtie' if defined?(Rails)
