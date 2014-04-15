module Harness
  class FakeCollector
    Increment = Struct.new(:name, :rate)
    Decrement = Struct.new(:name, :rate)
    Measurement = Struct.new(:name, :value, :rate)

    attr_reader :gauges, :counters, :timers, :increments, :decrements

    def initialize
      @gauges, @counters, @timers, @increments, @decrements = [], [], [], [], []
    end

    def timing(*args)
      timers << Measurement.new(*args)
    end

    def time(stat, sample_rate = 1)
      start = Time.now
      result = yield
      timing(stat, ((Time.now - start) * 1000).round, sample_rate)
      result
    end

    def increment(*args)
      increments << Increment.new(*args)
    end

    def decrement(*args)
      decrements << Decrement.new(*args)
    end

    def count(*args)
      counters << Measurement.new(*args)
    end

    def gauge(*args)
      gauges << Measurement.new(*args)
    end
  end
end
