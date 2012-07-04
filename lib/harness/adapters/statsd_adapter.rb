require 'statsd-instrument'

module Harness
  class StatsdAdapter
    class Config
      delegate :host, :port, :default_sample_rate, :mode, :logger, :to => :backend
      delegate :host=, :port=, :default_sample_rate=, :mode=, :logger=, :to => :backend

      def backend=(value)
        @backend = value
      end

      def backend
        @backend ||= StatsD
      end
    end

    def self.config
      @config ||= Config.new
    end

    def log_gauge(gauge)
      validate!
      backend.gauge sanitize(gauge.id), gauge.value
    end

    def log_counter(counter)
      validate!
      backend.increment sanitize(counter.id), counter.value
    end

    private
    def validate!
      raise "Adapter not configured. Ensure host and port are set." unless config.host and config.port
    end

    def sanitize(name)
      key = Harness.config.namespace ? "#{Harness.config.namespace}.#{name}" : name
      key.gsub(%r{[^a-z0-9]}, '.')
    end

    def backend
      config.backend
    end

    def config
      self.class.config
    end
  end
end
