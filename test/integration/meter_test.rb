require 'test_helper'

class CountersWithRedis < IntegrationTest
  def test_counters_can_act_like_gauges
    50.times { instrument "event-counter", :counter => true }

    meter = Harness::Meter.new 'event-counter'
    assert_equal 50, meter.per_second
    assert_equal 50, meter.per_minute
    assert_equal 50, meter.per_month
  end

  def tests_raises_an_error_when_no_such_counter
    assert_raises Harness::NoCounter do
      Harness::Meter.new 'unknown-counter'
    end
  end
end
