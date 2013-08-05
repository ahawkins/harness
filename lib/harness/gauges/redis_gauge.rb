module Harness
  class RedisGauge
    include Instrumentation

    attr_reader :redis

    def initialize(redis)
      @redis = redis
    end

    def log
      info = redis.info
      gauge 'redis.memory', info.fetch('used_memory').to_i
    end
  end
end
