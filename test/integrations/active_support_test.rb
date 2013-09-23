require_relative '../test_helper'
require 'harness/integration/active_support'

class ActiveSupportIntegration < MiniTest::Unit::TestCase
  def test_logs_cache_read
    instrument "cache_read"
    assert_timer "active_support.cache_read"
  end

  def test_logs_cache_generate
    instrument "cache_generate"
    assert_timer "active_support.cache_generate"
  end

  def test_logs_cache_fetch_hit
    instrument "cache_fetch_hit"
    assert_timer "active_support.cache_fetch_hit"
  end

  def test_logs_cache_write
    instrument "cache_write"
    assert_timer "active_support.cache_write"
  end

  def test_logs_cache_delete
    instrument "cache_delete"
    assert_timer "active_support.cache_delete"
  end

  private
  def instrument(event)
    super "#{event}.active_support", { }
  end
end
