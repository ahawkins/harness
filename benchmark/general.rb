require 'bundler/setup'
require 'statsd'
require 'harness'
require 'benchmark'
require 'redis'

Harness.config.statsd = Statsd.new

n = 10_000
redis = Redis.new

Benchmark.bm 20 do |x|
  x.report 'Notifications' do
    n.times do
      ActiveSupport::Notifications.instrument 'test', counter: true
    end
  end

  x.report 'Directly w/threading' do
    Harness.config.queue = Harness::ThreadedQueue.new

    n.times do |i|
      Harness.increment "test-#{i}"
    end
  end

  x.report 'Directly w/o threading' do
    Harness.config.queue = Harness::SynchronousQueue.new

    n.times do |i|
      Harness.increment "test-#{i}"
    end
  end

  x.report 'Legacy' do
    n.times do |i|
      redis.zadd 'meters', i, Time.now.to_i
      redis.sadd 'counters', i

      # simulate calls which would go to sidekiq
      redis.smembers 'workers'
      redis.sadd 'workers.foo', i
      redis.sadd 'workers.foo', rand

      ActiveSupport::Notifications.instrument 'test', counter: true
    end
  end
end

redis.flushdb
