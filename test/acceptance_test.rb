require_relative 'test_helper'

class AcceptanceTest < MiniTest::Unit::TestCase
  def test_works_with_actual_statsd
    Harness.config.collector = Statsd.new
    Harness.config.queue = Harness::SyncQueue.new

    Harness.increment 'foo', 0.6
    Harness.decrement 'foo', 0.5
    Harness.count 'foo', 5, 0.5

    Harness.gauge 'foo', 0.5, 0.1

    Harness.timing 'foo', 0.5, 0.1

    Harness.time 'foo', 1 do
      true
    end
  end

  def test_time_deltas_are_calculated_in_milliseconds
    start = Time.now
    finish = start + 2.5

    assert_equal 2500, Harness.delta(start, finish)
  end
end
