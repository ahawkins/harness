module Harness
  class Gauge < Measurement
    def initialize(attributes = {})
      super
      self.units ||= :ms
    end

    def self.from_event(event)
      if event.payload[:gauge].is_a? Hash
        gauge = new event.payload[:gauge]
      elsif event.payload[:gauge].is_a?(Symbol) || event.payload[:gauge].is_a?(String)
        gauge = new :id => event.payload[:gauge].to_s
      else
        gauge = new
      end

      gauge.id ||= event.name
      gauge.value ||= event.duration

      gauge
    end
  end
end
