require 'test_helper'

class ActiveSupportIntegration < IntegrationTest
  def test_logs_cache_read
    instrument "cache_read"

    assert_gauge_logged "cache_read.active_support"
  end

  def test_logs_cache_generate
    instrument "cache_generate"

    assert_gauge_logged "cache_generate.active_support"
  end

  def test_logs_cache_fetch_hit
    instrument "cache_fetch_hit"

    assert_gauge_logged "cache_fetch_hit.active_support"
  end

  def test_logs_cache_write
    instrument "cache_write"

    assert_gauge_logged "cache_write.active_support"
  end

  def test_logs_cache_delete
    instrument "cache_delete"

    assert_gauge_logged "cache_delete.active_support"
  end

  private
  def instrument(event)
    require 'harness/integration/active_support'
    ActiveSupport::Notifications.instrument "#{event}.active_support" do |*args|
      # nada
    end
  end
end
