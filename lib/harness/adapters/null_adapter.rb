module Harness
  class NullAdapter
    def self.gauges
      @gauges ||= []
    end

    def self.counters
      @counters ||= []
    end

    def log_gauge(gauge)
      self.class.gauges << gauge
    end

    def log_counter(counter)
      self.class.counters << counter
    end

    def gauges
      self.class.gauges
    end

    def counters
      self.class.counters
    end
  end
end
