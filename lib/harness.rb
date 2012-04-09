require "harness/version"

require 'thread'

require 'securerandom'

require 'active_support/notifications'
require 'active_support/core_ext/string'

module Harness
  def self.adapter=(val)
    if val.is_a? Symbol
      @adapter = "Harness::#{val.to_s.classify}Adapter".constantize
    else
      @adapter = val
    end
  end

  def self.adapter
    @adapter
  end

  def self.queue
    @queue ||= Queue.new
  end

  def self.consumer
    Thread.current["#{object_id}_harness_consumer_"] ||= Consumer.new
  end

  def self.log(measurement)
    queue << measurement
    wait if test_mode
  end

  def self.mutex
    @mutex ||= Mutex.new
  end

  def self.wait
    sleep 0.01 until consumer.finished? && queue.empty?
  end

  def self.test_mode
    @test_mode
  end

  def self.test_mode=(mode)
    @test_mode = mode
  end
end

require 'harness/measurement'
require 'harness/counter'
require 'harness/gauge'

require 'harness/instrumentation'

require 'harness/consumer'

require 'harness/adapters/librato_adapter'
require 'harness/adapters/null_adapter'

require 'harness/integration/action_controller'
require 'harness/integration/action_view'
require 'harness/integration/action_mailer'
require 'harness/integration/active_support'

Harness.consumer.consume
