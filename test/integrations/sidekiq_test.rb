require_relative '../test_helper'
require 'sidekiq'
require 'harness/integration/sidekiq'

class SidekiqIntegrationTest < MiniTest::Unit::TestCase
  def middleware
    Sidekiq::Middleware::Server::HarnessInstrumentation.new
  end

  def tests_times_the_given_job
    middleware.call("report", nil, nil) { }

    assert_timer "sidekiq.report"
  end

  def test_measures_jobs_per_second
    middleware.call("report", nil, nil) { }

    assert_increment "sidekiq.report"
  end

  def tests_logs_a_counter_of_all_jobs
    middleware.call("reports", nil, nil) { }

    assert_increment "sidekiq.job"
  end
end
