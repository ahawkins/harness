
module Harness
  class StatsdAdapter
    class Config
      attr_accessor :host, :port, :sample_rate, :backend

      def host=(value)
        @host = value
        Statsd.host = @host
      end

      def port=(value)
        @port = value
        Statsd.port = @port
      end

      def sample_rate=(value)
        @sample_rate = value
        Statsd.default_sample_rate = @sample_rate
      end

      def backend
        @backend ||= Statsd
      end
    end

    def self.backend
      config.backend
    end

    def self.config
      @config ||= Config.new
    end

    def self.log_gauge(gauge)
      validate gauge
      raise Harness::LoggingError if gauge.id.length > 63

      Statsd.gauge sanitize(gauge.id), gauge.value
    end

    def self.log_counter(counter)
      validate counter

      Statsd.increment sanitize(counter.id), counter.value
    end

    private
    def self.validate(obj)
      raise Harness::LoggingError if obj.id.length > 63
      raise "Adapter not configured. Ensure host and port are set." unless config.host and config.port
    end

    def self.sanitize(name)
      key = if Harness.config.namespace
        key = "#{Harness.config.namespace}.#{name}"
      else
        key = name
      end

      key.gsub(%r{[^a-z0-9]}, '.')
    end
  end
end
