module Harness
  class MemoryAdapter
    def self.gauges
      @gauges ||= []
    end

    def self.counters
      @counters ||= []
    end

    def log_gauge(gauge)
      gauges << gauge
    end

    def log_counter(counter)
      counters << counter
    end

    def counters
      self.class.counters
    end

    def gauges
      self.class.gauges
    end
  end
end
