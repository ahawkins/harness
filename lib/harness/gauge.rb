module Harness
  class Gauge < Measurement
    def self.from_event(event)
      gauge = new
      gauge.name = event.name
      gauge.value = event.duration / 1000

      if event.payload[:gauge].is_a? Hash
        gauge.source = event.payload[:gauge][:source]
      end

      gauge
    end
  end
end
