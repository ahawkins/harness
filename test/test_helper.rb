require 'simplecov'
SimpleCov.start

require 'resque'
require 'sidekiq'

require 'harness'

require 'minitest/unit'
require 'minitest/pride'
require 'minitest/autorun'

require 'webmock/minitest'

WebMock.disable_net_connect!

Harness.logger = Logger.new '/dev/null'

Harness.redis = Redis::Namespace.new 'harness-test', :redis => Redis.connect(:host => 'localhost', :port => '6379')

class IntegrationTest < MiniTest::Unit::TestCase
  def setup
    Harness.config.adapter = :memory
    Harness.config.queue = :syncronous

    gauges.clear ; counters.clear
    redis.flushall
  end

  def assert_gauge_logged(name)
    refute_empty gauges.select {|g| g.name = name }, "Expected #{gauges.inspect} to contain a #{name} result"
  end

  def assert_counter_logged(name)
    refute_empty counters.select {|c| c.name = name }, "Expected #{counters.inspect} to contain a #{name} result"
  end

  def assert_gauge_not_logged(name)
    assert_empty gauges.select {|g| g.name = name }, "No gauge expected to be logged"
  end

  def assert_counter_not_logged(name)
    assert_empty counters.select {|c| c.name = name }, "No counter expected to be logged"
  end

  def gauges
    Harness::MemoryAdapter.gauges
  end

  def counters
    Harness::MemoryAdapter.counters
  end

  def redis
    Harness.redis
  end

  def instrument(name, data = {})
    ActiveSupport::Notifications.instrument name, data do 
      # nothing
    end
  end
end
