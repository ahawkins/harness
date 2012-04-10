require 'test_helper'
require 'harness/queues/resque_queue'

class ResqueTest < IntegrationTest
  def setup
    super
    Resque.inline = true
    Harness.config.queue = :resque
  end

  def test_a_gauge_is_logged
    instrument "test-gauge", :gauge => true

    assert_gauge_logged "test-gauge"
  end

  def test_a_counter_is_logged
    instrument "test-counter", :counter => true

    assert_counter_logged "test-counter"
  end
end
