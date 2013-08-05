module Harness
  class SidekiqGauge
    include Instrumentation

    def log
      stats = Sidekiq::Stats.new

      gauge 'sidekiq.jobs.processed', stats.processed
      gauge 'sidekiq.jobs.enqueued', stats.enqueued
      gauge 'sidekiq.jobs.failed', stats.failed
      gauge 'sidekiq.jobs.retries', stats.failed
      gauge 'sidekiq.jobs.scheduled', stats.scheduled_size
    end
  end
end
