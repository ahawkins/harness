module Harness
  class ResqueQueue
    class SendGauge < Job
      @queue = :metrics

      def self.perform(attributes)
        gauge = Gauge.new attributes
        new.log gauge
      end
    end

    class SendCounter < Job
      @queue = :metrics

      def self.perform(attributes)
        counter = Counter.new attributes
        new.log counter
      end
    end

    def push(measurement)
      if measurement.is_a? Gauge
        Resque.enqueue SendGauge, measurement.attributes
      elsif measurement.is_a? Counter
        Resque.enqueue SendCounter, measurement.attributes
      end
    end
  end
end
