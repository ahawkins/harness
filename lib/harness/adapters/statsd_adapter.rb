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

    def self.backend
      config.backend
    end

    def self.config
      @config ||= Config.new
    end

    def self.log_gauge(gauge)
      validate!
      backend.gauge sanitize(gauge.id), gauge.value
    end

    def self.log_counter(counter)
      validate!
      backend.increment sanitize(counter.id), counter.value
    end

    private
    def self.validate!
      raise "Adapter not configured. Ensure host and port are set." unless config.host and config.port
    end

    def self.sanitize(name)
      key = Harness.config.namespace ? "#{Harness.config.namespace}.#{name}" : name
      key.gsub(%r{[^a-z0-9]}, '.')
    end
  end
end
