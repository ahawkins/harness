module Harness
  class Meter
    def initialize(name)
      @name = name
    end

    def per_second
      per 1.second
    end

    def per_minute
      per 1.minute
    end

    def per_month
      per 1.month
    end

    def per(rate, base = Time.now)
      redis.zcount(key, base.to_i - rate, base.to_i)
    end

    private
    def key
      "meters/#{@name}"
    end

    def redis
      Harness.redis
    end
  end
end
