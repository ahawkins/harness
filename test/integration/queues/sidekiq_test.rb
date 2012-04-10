require 'test_helper'
require 'harness/queues/sidekiq_queue'
require 'sidekiq/testing'

class SidekiqTest < IntegrationTest
  def setup
    super
    Harness.config.queue = :sidekiq
  end

  def test_a_gauge_is_logged
    instrument "test-gauge", :gauge => true

    refute_empty Harness::SidekiqQueue::SendGauge.jobs

    args = Harness::SidekiqQueue::SendGauge.jobs.first['args'].first
    Harness::SidekiqQueue::SendGauge.new.perform args

    assert_gauge_logged "test-gauge"
  end

  def test_a_counter_is_logged
    instrument "test-counter", :counter => true

    refute_empty Harness::SidekiqQueue::SendCounter.jobs

    args = Harness::SidekiqQueue::SendCounter.jobs.first['args'].first
    Harness::SidekiqQueue::SendCounter.new.perform args

    assert_counter_logged "test-counter"
  end
end
