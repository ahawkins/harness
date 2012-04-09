require 'test_helper'

class MemoryAdapterTest < MiniTest::Unit::TestCase
  def setup
    Harness::MemoryAdapter.counters.clear
    Harness::MemoryAdapter.gauges.clear

    @adapter = Harness::MemoryAdapter
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
