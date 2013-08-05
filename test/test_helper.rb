require 'bundler/setup'

require 'simplecov'
SimpleCov.start

require 'harness'

require 'minitest/unit'
require 'minitest/autorun'

class FakeStatsd
  Increment = Struct.new(:name, :rate)
  Gauge = Struct.new(:name, :value, :rate)

  attr_reader :gauges, :counters, :timers, :increments

  def initialize
    @gauges, @counters, @timers, @increments = [], [], [], []
  end

  def timing(*args)
    timers << Harness::Timer.new(*args)
  end

  def time(stat, sample_rate = 1)
    start = Time.now
    result = yield
    timing(stat, ((Time.now - start) * 1000).round, sample_rate)
    result
  end 

  def increment(*args)
    increments << Increment.new(*args)
  end

  def count(*args)
    counters << Harness::Counter.new(*args)
  end

  def gauge(*args)
    gauges << Gauge.new(*args)
  end
end

class MiniTest::Unit::TestCase
  def setup
    Harness.config.statsd = FakeStatsd.new
    Harness.config.queue = Harness::SynchronousQueue.new
  end

  def assert_timer(name)
    refute_empty timers
    timer = timers.find { |t| t.name == name }
    assert timer, "Timer #{name} not logged!"
  end

  def assert_increment(name)
    refute_empty increments
    increment = increments.find { |i| i.name == name }
    assert increment, "Increment #{name} not logged!"
  end

  def assert_gauge(name)
    refute_empty gauges
    gauge = gauges.find { |g| g.name == name }
    assert gauge, "gauge #{name} not logged!"
  end

  def instrument(name, data = {}, &block)
    ActiveSupport::Notifications.instrument name, data, &block
  end

  def statsd
    Harness.config.statsd
  end

  def timers
    statsd.timers
  end

  def increments
    statsd.increments
  end

  def counters
    statsd.counters
  end

  def gauges
    statsd.gauges
  end
end
