require 'test_helper'

class CountersWithRedis < IntegrationTest
  def test_counters_can_act_like_gauges
    50.times { instrument "event-counter", :counter => true }

    meter = Harness::Meter.new 'event-counter'
    assert_equal 50, meter.per_second.value
    assert_equal 50, meter.per_minute.value
    assert_equal 50, meter.per_hour.value
  end

  def tests_raises_an_error_when_no_such_counter
    assert_raises Harness::NoCounter do
      Harness::Meter.new 'unknown-counter'
    end
  end

  def test_rates_return_gauges
    50.times { instrument "event-counter", :counter => true }

    meter = Harness::Meter.new 'event-counter'

    gauge = meter.per_second

    assert_kind_of Harness::Gauge, gauge

    assert_equal "event-counter-per-second", gauge.id
    assert_equal "event-counter per second", gauge.name
    assert_kind_of Time, gauge.time
  end
end
