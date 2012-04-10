module Harness
  class Counter < Measurement
    def self.from_event(event)
      if event.payload[:counter].is_a? Hash
        counter = new event.payload[:counter]
      else
        counter = new
      end

      counter.id ||= event.name

      if event.payload[:counter].is_a? Fixnum
        counter.value = event.payload[:counter]
      end

      counter
    end
  end
end
