module Harness
  class NullStatsd
    def increment(*args)

    end

    def count(*args)

    end

    def time(*args, &block)
      yield block
    end

    def timing(*args)

    end

    def gauge(*args)

    end
  end
end
