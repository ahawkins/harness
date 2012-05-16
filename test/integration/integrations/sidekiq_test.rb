require 'test_helper'
require 'sidekiq'
require 'harness/integration/sidekiq'

class SidekiqIntegrationTest < IntegrationTest
  def middleware
    Sidekiq::Middleware::Server::HarnessInstrumentation.new
  end

  def tests_logs_job_performance_stats
    middleware.call("report", nil, nil) { }

    assert_gauge_logged "report.sidekiq"
    assert_counter_logged "reports.sidekiq"
  end

  def tests_logs_a_counter_of_all_jobs
    middleware.call("reports", nil, nil) { }

    assert_counter_logged "job.sidekiq"
  end

  def test_ignores_harness_jobs
    middleware.call("Harness::SidekiqQueue::SendCounter", nil, nil) { }

    assert_empty counters
    assert_empty gauges

    middleware.call("Harness::SidekiqQueue::SendGauge", nil, nil) { }

    assert_empty counters
    assert_empty gauges
  end
end
