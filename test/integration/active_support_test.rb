require 'test_helper'

class ActiveSupportTestCase < MiniTest::Unit::TestCase
  def setup
    Harness.adapter = :null
    gauges.clear ; counters.clear
  end

  def test_a_gauge_is_logged
    ActiveSupport::Notifications.instrument "gauge_test.harness", :gauge => true do |args|
      # do nothing
    end

    refute_empty gauges.select {|g| g.name = "gauge_test.harness" }, "Expected #{gauges.inspect} to contain a gauge_test.harness result"
  end

  def test_a_counter_is_logged
    ActiveSupport::Notifications.instrument "counter_test.harness", :counter => { :value => 5 } do |args|
      # do nothing
    end

    refute_empty counters.select {|g| g.name = "counter_test.harness" }, "Expected #{gauges.inspect} to contain a counter_test.harness result"
  end

  def gauges
    Harness::NullAdapter.gauges
  end

  def counters
    Harness::NullAdapter.counters
  end
end
