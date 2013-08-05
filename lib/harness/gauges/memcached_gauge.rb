module Harness
  class MemcachedGauge
    include Instrumentation

    attr_reader :memcached

    def initialize(memcached)
      @memcached = memcached
    end

    def log
      stats = memcached.stats

      memory = stats.reduce(0) do |i, pair|
        i + pair.last.fetch('bytes').to_i
      end

      total_keys = stats.reduce(0) do |i, pair|
        i + pair.last.fetch('curr_items').to_i
      end

      total_requests = stats.reduce(0) do |i, pair|
        i + pair.last.fetch('cmd_get').to_i
      end

      total_hits = stats.reduce(0) do |i, pair|
        i + pair.last.fetch('get_hits').to_i
      end

      if total_requests > 0
        hit_rate = (total_hits / total_requests).to_f
      else
        hit_rate = 0
      end

      gauge 'memcached.memory', memory
      gauge 'memcached.keys', total_keys
      gauge 'memcached.hit_rate', hit_rate
    end
  end
end
