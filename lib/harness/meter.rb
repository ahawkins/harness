module Harness
  class Meter
    def initialize(name)
      @name = name

      raise Harness::NoCounter, "#{@name} is not being metered" unless redis.exists key
    end

    def per_second
      per 1.second
    end

    def per_minute
      per 1.minute
    end

    def per_hour
      per 1.hour
    end

    def per(rate, base = Time.now)
      gauge = Gauge.new :value => redis.zcount(key, base.to_f - rate, base.to_f)

      if words = rate_in_words(rate)
        gauge.name = "#{@name} per #{words}"
        gauge.id = "#{@name}-per-#{words}"
      else
        gauge.id = "#{@name} gauge"
      end

      gauge.time = Time.now

      gauge
    end

    private
    def key
      "meters/#{@name}"
    end

    def redis
      Harness.redis
    end

    def rate_in_words(rate)
      if rate < 1.minute
        "second"
      elsif rate >= 1.minute && rate < 1.hour
        "minute"
      elsif rate >= 1.hour && rate < 1.day
        "hour"
      end
    end
  end
end
