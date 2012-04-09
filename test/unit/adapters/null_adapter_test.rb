require 'test_helper'

class NullAdapterTest < MiniTest::Unit::TestCase
  def setup
    Harness::NullAdapter.counters.clear
    Harness::NullAdapter.gauges.clear

    @adapter = Harness::NullAdapter
  end

  def test_log_gauge_adds_to_gauges
    @adapter.log_gauge :foo

    assert_includes @adapter.gauges, :foo
  end

  def test_log_counter_adds_to_counters
    @adapter.log_counter :bar

    assert_includes @adapter.counters, :bar
  end
end
