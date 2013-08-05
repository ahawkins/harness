require 'bundler/setup'
require 'statsd'
require 'harness'
require 'benchmark'
require 'redis'

Harness.config.statsd = Statsd.new

n = 10_000
redis = Redis.new

Benchmark.bm do |x|
  x.report "w/o instrumentation" do
    n.times do |i|
      redis.set "foo.#{rand}", 1
    end
  end

  require 'harness/integration/redis'
  x.report 'w/ instrumentation' do
    n.times do |i|
      redis.set "foo.#{rand}", 1
    end
  end
end

redis.flushdb
