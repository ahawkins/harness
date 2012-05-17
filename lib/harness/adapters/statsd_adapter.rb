require 'statsd-instrument'

module Harness
  class StatsdAdapter
    class Config
      attr_accessor :host, :port, :sample_rate, :backend, :logger, :mode

      def initialize(conf)
        return self unless conf
        conf.each do |key,val|
          self.send "#{key}=", val
        end
      end

      def host=(value)
        @host = value
        backend.host = @host
      end

      def port=(value)
        @port = value
        backend.port = @port
      end

      def sample_rate=(value)
        @sample_rate = value
        backend.default_sample_rate = @sample_rate
      end

      def logger=(value)
        @logger = value
        backend.logger = @logger
      end

      def mode=(value)
        @mode = value
        backend.mode = @mode
      end

      def backend
        @backend ||= StatsD
      end
    end

    def self.backend
      config.backend
    end

    def self.config(config = nil)
      @config ||= Config.new(config)
    end

    def self.log_gauge(gauge)
      validate gauge
      set_defaults
      backend.gauge sanitize(gauge.id), gauge.value
    end

    def self.log_counter(counter)
      validate counter
      set_defaults
      backend.increment sanitize(counter.id), counter.value
    end

    private
    def self.validate(obj)
      raise "Adapter not configured. Ensure host and port are set." unless config.host and config.port
    end

    def self.sanitize(name)
      key = Harness.config.namespace ? "#{Harness.config.namespace}.#{name}" : name
      key.gsub(%r{[^a-z0-9]}, '.')
    end

    def self.set_defaults
      # as Rails.logger is nil when we are initialized,
      # we need to set the logger at runtime
      config.logger ||= Rails.logger
      config.mode ||= Rails.env
    end
  end
end
