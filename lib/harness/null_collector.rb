module Harness
  class NullCollector
    def increment(*args)

    end

    def decrement(*args)

    end

    def count(*args)

    end

    def time(*args)
      yield
    end

    def timing(*args)

    end

    def gauge(*args)

    end
  end
end
