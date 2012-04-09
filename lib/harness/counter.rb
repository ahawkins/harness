module Harness
  class Counter < Measurement
    def self.from_event(event)
      counter = new
      counter.name = event.name

      if event.payload[:counter].is_a? Hash
        counter.source = event.payload[:counter][:source]
        counter.value = event.payload[:counter][:value]
      end

      if event.payload[:counter].is_a? Fixnum
        counter.value = event.payload[:counter]
      end

      counter
    end
  end
end
