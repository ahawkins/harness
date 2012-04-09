module Harness
  class NullAdapter
    def self.gauges
      @gauges ||= []
    end

    def self.counters
      @counters ||= []
    end

    def self.log_gauge(gauge)
      gauges << gauge
    end

    def self.log_counter(counter)
      counters << counter
    end
  end
end
