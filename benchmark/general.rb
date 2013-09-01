require 'bundler/setup'
require 'statsd'
require 'harness'
require 'benchmark'

Harness.config.statsd = Statsd.new

n = 10_000

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
end

redis.flushdb
