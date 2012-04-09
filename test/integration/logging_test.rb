require 'test_helper'

class HarnessTest < IntegrationTest
  def test_gauges_are_logged
    gauge = Harness::Gauge.new :name => 'minitest'
    gauge.log

    assert_includes gauges, gauge
  end

  def test_counters_are_logged
    counter = Harness::Counter.new :name => 'minitest'
    counter.log

    assert_includes counters, counter
  end
end
