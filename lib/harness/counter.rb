module Harness
  class Counter < Measurement
    def self.from_event(event)
      if event.payload[:counter].is_a? Hash
        counter = new event.payload[:counter]
      else
        counter = new
      end

      counter.id ||= event.name

      Harness.redis.sadd 'counters', counter.id

      if event.payload[:counter].is_a? Fixnum
        counter.value = event.payload[:counter]
      end

      if counter.value
        Harness.redis.set counter.id, counter.value
      else
        counter.value = Harness.redis.incr(counter.id).to_i
      end

      counter
    end
  end
end
