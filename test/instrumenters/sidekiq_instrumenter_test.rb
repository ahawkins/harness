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

class SidekiqInstrumenterTest < MiniTest::Unit::TestCase
  def test_reports_processed_jobs
    instrumentor = Harness::SidekiqInstrumenter.new
    instrumentor.log

    assert_gauge 'sidekiq.jobs.processed'
  end

  def test_reports_enqueued_jobs
    instrumentor = Harness::SidekiqInstrumenter.new
    instrumentor.log

    assert_gauge 'sidekiq.jobs.enqueued'
  end

  def test_reports_failed_jobs
    instrumentor = Harness::SidekiqInstrumenter.new
    instrumentor.log

    assert_gauge 'sidekiq.jobs.failed'
  end

  def test_reports_retries
    instrumentor = Harness::SidekiqInstrumenter.new
    instrumentor.log

    assert_gauge 'sidekiq.jobs.retries'
  end

  def test_reports_scheduled_jobs
    instrumentor = Harness::SidekiqInstrumenter.new
    instrumentor.log

    assert_gauge 'sidekiq.jobs.scheduled'
  end
end
