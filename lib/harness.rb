require "harness/version"

require 'statsd'
require 'singleton'

module Harness
  Config = Class.new do
    include Singleton
    attr_accessor :collector, :queue
  end.instance

  def self.config
    Config
  end

  def self.increment(stat, sample_rate = 1)
    queue.push [:increment, [stat, sample_rate]]
  end

  def self.decrement(stat, sample_rate = 1)
    queue.push [:decrement, [stat, sample_rate]]
  end

  def self.count(stat, value, sample_rate = 1)
    queue.push [:count, [stat, value, sample_rate]]
  end

  def self.timing(start, ms, sample_rate = 1)
    queue.push [:timing, [start, ms, sample_rate]]
  end

  def self.time(stat, sample_rate = 1)
    start = Time.now
    result = yield
    timing(stat, delta(start), sample_rate)
    result
  end

  def self.delta(start, finish = Time.now)
    ((finish - start) * 1000).round
  end

  def self.gauge(stat, value, sample_rate = 1)
    queue.push [:gauge, [stat, value, sample_rate]]
  end

  def self.queue
    config.queue
  end

  def self.collector
    config.collector
  end
end

require 'harness/sync_queue'
require 'harness/async_queue'

require 'harness/null_collector'
require 'harness/fake_collector'

require 'harness/instrumentation'

Harness.config.queue = Harness::AsyncQueue.new
