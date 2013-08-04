module Harness
  class RedisInstrumenter
    attr_reader :redis

    def initialize(redis)
      @redis = redis
    end

    def log
      info = redis.info
      statsd.gauge 'redis.memory', info.fetch('used_memory').to_i
    end

    def statsd
      Harness.config.statsd
    end
  end
end
