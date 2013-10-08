module Harness
  class FakeCollector
    Increment = Struct.new(:name, :amount, :rate)
    Decrement = Struct.new(:name, :amount, :rate)
    Gauge = Struct.new(:name, :value, :rate)

    attr_reader :gauges, :counters, :timers, :increments, :decrements

    def initialize
      @gauges, @counters, @timers, @increments, @decrements = [], [], [], [], []
    end

    def timing(*args)
      timers << Harness::Timer.new(*args)
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
      counters << Harness::Counter.new(*args)
    end

    def gauge(*args)
      gauges << Gauge.new(*args)
    end
  end
end
