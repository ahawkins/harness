require 'securerandom'

module Harness
  class Counter < Measurement
    def self.from_event(event)
      if event.payload[:counter].is_a? Hash
        counter = new event.payload[:counter]
      elsif event.payload[:counter].is_a?(Symbol) || event.payload[:counter].is_a?(String)
        counter = new :id => event.payload[:counter].to_s
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

      Harness.redis.zadd "meters/#{counter.id}", counter.time.to_i, counter.value

      counter
    end
  end
end
