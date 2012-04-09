require "harness/version"

require 'thread'

require 'securerandom'

require 'active_support/notifications'
require 'active_support/core_ext/string'

module Harness
  class Config
    attr_reader :adapter
    attr_accessor :test_mode, :enabled

    def adapter=(val)
      if val.is_a? Symbol
        @adapter = "Harness::#{val.to_s.classify}Adapter".constantize
      else
        @adapter = val
      end
    end

    def method_missing(name, *args, &block)
      begin
        "Harness::#{name.to_s.classify}Adapter".constantize.config
      rescue NameError
        super
      end
    end
  end

  def self.config
    @config ||= Config.new
  end

  def self.queue
    @queue ||= Queue.new
  end

  def self.consumer
    Thread.current["#{object_id}_harness_consumer_"] ||= Consumer.new
  end

  def self.log(measurement)
    return unless config.enabled

    queue << measurement
    wait if config.test_mode
  end

  def self.mutex
    @mutex ||= Mutex.new
  end

  def self.wait
    sleep 0.01 until consumer.finished? && queue.empty?
  end
end

require 'harness/measurement'
require 'harness/counter'
require 'harness/gauge'

require 'harness/instrumentation'

require 'harness/consumer'

require 'harness/adapters/librato_adapter'
require 'harness/adapters/memory_adapter'

require 'harness/integration/action_controller'
require 'harness/integration/action_view'
require 'harness/integration/action_mailer'
require 'harness/integration/active_support'

require 'harness/railtie' if defined?(Rails)

Harness.consumer.consume
