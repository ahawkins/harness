module Harness
  class SidekiqQueue
    class SendGauge < Job
      include Sidekiq::Worker
      sidekiq_options :queue => :metrics

      def perform(attributes)
        gauge = Gauge.new attributes
        log gauge
      end
    end

    class SendCounter < Job
      include Sidekiq::Worker
      sidekiq_options :queue => :metrics

      def perform(attributes)
        counter = Counter.new attributes
        log counter
      end
    end

    def push(measurement)
      if measurement.is_a? Gauge
        SendGauge.perform_async measurement.attributes
      elsif measurement.is_a? Counter
        SendCounter.perform_async measurement.attributes
      end
    end
  end
end
