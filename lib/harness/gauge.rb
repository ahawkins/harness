module Harness
  class Gauge < Measurement
    def self.from_event(event)
      if event.payload[:gauge].is_a? Hash
        gauge = new event.payload[:gauge]
      else
        gauge = new
      end

      gauge.name = event.name
      gauge.value = event.duration / 1000

      gauge
    end
  end
end
