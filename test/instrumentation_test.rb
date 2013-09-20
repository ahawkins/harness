require_relative 'test_helper'

class InstrumentationTest < MiniTest::Unit::TestCase
  class Worker
    include Harness::Instrumentation
  end

  attr_reader :worker

  def setup
    @worker = Worker.new
  end

  def test_can_use_increments
    worker.increment 'foo', 0.5
    assert_increment 'foo'
  end

  def test_can_use_decrements
    worker.decrement 'foo', 0.5
    assert_decrement 'foo'
  end

  def test_can_use_gauges
    worker.gauge 'foo', 5, 0.5
    assert_gauge 'foo'
  end

  def test_can_use_timings
    worker.timing 'foo', 5, 0.5
    assert_timer 'foo'
  end

  def test_can_be_timed
    result = worker.time 'foo', 0.5 do
      'bar'
    end

    assert_equal 'bar', result, "#time did not return block's value"
    assert_timer 'foo'
  end

  def test_instruments_timing_and_counters
    result = worker.instrument 'foo', 0.5 do
      'bar'
    end

    assert_equal 'bar', result, "#instrument did not return block's value"
    assert_increment 'foo'
    assert_timer 'foo'
  end

  def test_also_works_with_extend
    extended = Class.new do
      extend Harness::Instrumentation
    end

    assert_respond_to extended, :increment
    assert_respond_to extended, :decrement
    assert_respond_to extended, :time
    assert_respond_to extended, :timing
    assert_respond_to extended, :gauge
    assert_respond_to extended, :instrument
  end
end
