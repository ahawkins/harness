module Harness
  class RedisGauge
    attr_reader :redis

    def initialize(redis)
      @redis = redis
    end

    def log
      info = redis.info
      Harness.gauge 'redis.memory', info.fetch('used_memory').to_i
    end
  end
end
