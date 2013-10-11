module Harness
  module Instrumentation
    def timing(*args)
      Harness.timing *args
    end

    def time(*args, &block)
      Harness.time *args, &block
    end

    def gauge(*args)
      Harness.gauge *args
    end

    def increment(*args)
      Harness.increment *args
    end

    def decrement(*args)
      Harness.decrement *args
    end

    def count(*args)
      Harness.count *args
    end
  end
end
