module Harness
  class SidekiqGauge
    def log
      stats = Sidekiq::Stats.new

      Harness.gauge 'sidekiq.jobs.processed', stats.processed
      Harness.gauge 'sidekiq.jobs.enqueued', stats.enqueued
      Harness.gauge 'sidekiq.jobs.failed', stats.failed
      Harness.gauge 'sidekiq.jobs.retries', stats.failed
      Harness.gauge 'sidekiq.jobs.scheduled', stats.scheduled_size
    end
  end
end
