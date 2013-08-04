require 'bundler/setup'
require 'statsd'
require 'harness'
require 'benchmark'
require 'redis'

Harness.config.statsd = Statsd.new

n = 10_000
redis = Redis.new

Benchmark.bm 12 do |x|
  x.report 'Notifications' do
    n.times do
      ActiveSupport::Notifications.instrument 'test', counter: true
    end
  end

  x.report 'Directly' do
    n.times do
      Harness.increment 'test'
    end
  end

  x.report 'Legacy' do
    n.times do |i|
      redis.zadd 'meters', i, Time.now.to_i
      redis.sadd 'counters', i
      ActiveSupport::Notifications.instrument 'test', counter: true
    end
  end
end

redis.flushdb
