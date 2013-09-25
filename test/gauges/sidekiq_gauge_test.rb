require_relative '../test_helper'
require 'sidekiq'
require 'logger'

class NullLogger < Logger
  def initialize(*args)

  end

  def add(*args)

  end
end

Sidekiq.logger = NullLogger.new

class SidekiqGaugeTest < MiniTest::Unit::TestCase
  def test_reports_processed_jobs
    instrumentor = Harness::SidekiqGauge.new
    instrumentor.log

    assert_gauge 'sidekiq.jobs.processed'
  end

  def test_reports_enqueued_jobs
    instrumentor = Harness::SidekiqGauge.new
    instrumentor.log

    assert_gauge 'sidekiq.jobs.enqueued'
  end

  def test_reports_failed_jobs
    instrumentor = Harness::SidekiqGauge.new
    instrumentor.log

    assert_gauge 'sidekiq.jobs.failed'
  end

  def test_reports_retries
    instrumentor = Harness::SidekiqGauge.new
    instrumentor.log

    assert_gauge 'sidekiq.jobs.retries'
  end

  def test_reports_scheduled_jobs
    instrumentor = Harness::SidekiqGauge.new
    instrumentor.log

    assert_gauge 'sidekiq.jobs.scheduled'
  end

  def test_logs_all_metrics_in_given_namespace
    instrumentor = Harness::SidekiqGauge.new 'foo'
    instrumentor.log

    assert_gauge 'foo.sidekiq.jobs.processed'
    assert_gauge 'foo.sidekiq.jobs.enqueued'
    assert_gauge 'foo.sidekiq.jobs.failed'
    assert_gauge 'foo.sidekiq.jobs.retries'
    assert_gauge 'foo.sidekiq.jobs.scheduled'
  end
end
