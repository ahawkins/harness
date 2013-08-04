module Harness
  class SidekiqInstrumenter
    def log
      stats = Sidekiq::Stats.new

      statsd.gauge 'sidekiq.jobs.processed', stats.processed
      statsd.gauge 'sidekiq.jobs.enqueued', stats.enqueued
      statsd.gauge 'sidekiq.jobs.failed', stats.failed
      statsd.gauge 'sidekiq.jobs.retries', stats.failed
      statsd.gauge 'sidekiq.jobs.scheduled', stats.scheduled_size
    end

    def statsd
      Harness.config.statsd
    end
  end
end
