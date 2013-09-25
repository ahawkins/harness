module Harness
  class SidekiqGauge
    include Instrumentation

    def initialize(namespace = nil)
      @namespace = namespace
    end

    def log
      stats = Sidekiq::Stats.new

      gauge namespaced('sidekiq.jobs.processed'), stats.processed
      gauge namespaced('sidekiq.jobs.enqueued'), stats.enqueued
      gauge namespaced('sidekiq.jobs.failed'), stats.failed
      gauge namespaced('sidekiq.jobs.retries'), stats.failed
      gauge namespaced('sidekiq.jobs.scheduled'), stats.scheduled_size
    end

    private
    def namespaced(name)
      [@namespace, name].compact.join '.'
    end
  end
end
