require_relative '../test_helper'
require 'dalli'

class MemcachedInstrumenterTest < MiniTest::Unit::TestCase
  def test_reports_the_memory_as_a_gauge
    instrumentor = Harness::MemcachedInstrumenter.new(Dalli::Client.new)
    instrumentor.log

    assert_gauge 'memcached.memory'
  end

  def test_reports_the_total_itmes_as_a_gauge
    instrumentor = Harness::MemcachedInstrumenter.new(Dalli::Client.new)
    instrumentor.log

    assert_gauge 'memcached.keys'
  end

  def test_reports_the_hit_rage_as_gauge
    instrumentor = Harness::MemcachedInstrumenter.new(Dalli::Client.new)
    instrumentor.log

    assert_gauge 'memcached.hit_rate'
  end
end
