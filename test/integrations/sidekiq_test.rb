require_relative '../test_helper'
require 'sidekiq'
require 'harness/integration/sidekiq'

class SidekiqIntegrationTest < MiniTest::Unit::TestCase
  Report = Class.new

  def middleware
    Sidekiq::Middleware::Server::HarnessInstrumentation.new
  end

  def tests_times_the_given_job
    middleware.call(Report.new, nil, nil) { }

    assert_timer "sidekiq.sidekiq_integration_test.report"
  end

  def tests_logs_a_counter_of_all_jobs
    middleware.call(Report.new, nil, nil) { }

    assert_increment "sidekiq.job"
  end
end
