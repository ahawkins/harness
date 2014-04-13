require 'bundler/setup'

require 'harness'

require 'minitest/unit'

require 'mutant-minitest'

unless Mutant::Minitest.active?
  require 'minitest/autorun'
end

Thread.abort_on_exception = true

class MiniTest::Unit::TestCase
  def setup
    Harness.config.collector = Harness::FakeCollector.new
    Harness.config.queue = Harness::SyncQueue.new
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

  def assert_decrement(name)
    refute_empty decrements
    decrement = decrements.find { |i| i.name == name }
    assert decrement, "decrement #{name} not logged!"
  end

  def assert_gauge(name)
    refute_empty gauges
    gauge = gauges.find { |g| g.name == name }
    assert gauge, "gauge #{name} not logged!"
  end

  def assert_counter(name)
    refute_empty counters
    counter = counters.find { |g| g.name == name }
    assert counter, "counter #{name} not logged!"
  end

  def collector
    Harness.config.collector
  end

  def timers
    collector.timers
  end

  def increments
    collector.increments
  end

  def decrements
    collector.decrements
  end

  def counters
    collector.counters
  end

  def gauges
    collector.gauges
  end
end
