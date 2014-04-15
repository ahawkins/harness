require_relative 'test_helper'

class InstrumentationTest < MiniTest::Unit::TestCase
  class Worker
    include Harness::Instrumentation
  end

  attr_reader :worker

  def setup
    super
    @worker = Worker.new
  end

  def test_increment
    worker.increment 'foo'

    assert_increment 'foo' do |counter|
      assert_equal 1, counter.rate
    end

    worker.increment 'bar', 0.5

    assert_increment 'bar' do |counter|
      assert_equal 0.5, counter.rate, 'Default sample rate incorrect'
    end
  end

  def test_decrement
    worker.decrement 'foo'

    assert_decrement 'foo' do |counter|
      assert_equal 1, counter.rate
    end

    worker.decrement 'bar', 0.5

    assert_decrement 'bar' do |counter|
      assert_equal 0.5, counter.rate, 'Default sample rate incorrect'
    end
  end

  def test_count
    worker.count 'foo', 6

    assert_counter 'foo' do |counter|
      assert_equal 6, counter.value
      assert_equal 1, counter.rate, 'Default sample rate incorrect'
    end

    worker.count 'bar', 1, 0.5

    assert_counter 'bar' do |counter|
      assert_equal 1, counter.value
      assert_equal 0.5, counter.rate
    end
  end

  def test_can_use_gauges
    worker.gauge 'foo', 6

    assert_gauge 'foo' do |gauge|
      assert_equal 6, gauge.value
      assert_equal 1, gauge.rate, 'Default sample rate incorrect'
    end

    worker.gauge 'bar', 1, 0.5

    assert_gauge 'bar' do |gauge|
      assert_equal 1, gauge.value
      assert_equal 0.5, gauge.rate
    end
  end

  def test_can_use_timings
    worker.timing 'foo', 6

    assert_timer 'foo' do |timer|
      assert_equal 6, timer.value
      assert_equal 1, timer.rate, 'Default sample rate incorrect'
    end

    worker.timing 'bar', 1, 0.5

    assert_timer 'bar' do |timer|
      assert_equal 1, timer.value
      assert_equal 0.5, timer.rate
    end
  end

  def test_can_be_timed
    result = worker.time 'foo' do
      'bar'
    end

    assert_timer 'foo' do |timer|
      assert_instance_of Fixnum, timer.value
      assert_equal 1, timer.rate, 'Default sample rate incorrect'
    end

    result = worker.time 'baz', 0.5 do
      'bar'
    end

    assert_timer 'baz' do |timer|
      assert_equal 0.5, timer.rate
    end
  end

  def test_time_returns_block_value
    result = worker.time 'foo' do
      'bar'
    end

    assert_equal 'bar', result, "#time did not return block's value"
  end

  def test_timer_use_1_for_default_sample_rate
    result = worker.time 'foo' do
      'bar'
    end

    assert_timer 'foo' do |timer|
      assert_equal 1, timer.rate
    end
  end

  def test_also_works_with_extend
    extended = Class.new do
      extend Harness::Instrumentation
    end

    assert_respond_to extended, :increment
    assert_respond_to extended, :decrement
    assert_respond_to extended, :count
    assert_respond_to extended, :time
    assert_respond_to extended, :timing
    assert_respond_to extended, :gauge
  end
end
