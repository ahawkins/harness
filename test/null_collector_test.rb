require_relative 'test_helper'

class NullCollectorTest < MiniTest::Unit::TestCase
  attr_reader :statsd

  def setup
    @statsd = Harness::NullCollector.new
  end

  def test_respond_to_increment
    statsd.increment 'foo', 0.5
  end

  def test_respond_to_decrement
    statsd.decrement 'foo', 0.5
  end

  def test_respond_to_count
    statsd.count 'foo', 5, 0.5
  end

  def test_responds_to_timing
    statsd.timing 'foo', 5, 0.5
  end

  def test_responds_to_gauge
    statsd.gauge 'foo', 5, 0.5
  end

  def test_runs_the_block_for_time
    result = statsd.time 'foo', 0.5 do
      'bar'
    end

    assert_equal 'bar', result
  end
end
