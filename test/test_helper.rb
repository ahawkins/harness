require 'simplecov'
SimpleCov.start

require 'harness'

require 'minitest/unit'
require 'minitest/pride'
require 'minitest/autorun'

require 'webmock/minitest'

WebMock.disable_net_connect!

Thread.abort_on_exception = true

Harness.config.test_mode = true

class IntegrationTest < MiniTest::Unit::TestCase
  def setup
    Harness.config.adapter = :null
    gauges.clear ; counters.clear
  end

  def assert_gauge_logged(name)
    refute_empty gauges.select {|g| g.name = name }, "Expected #{gauges.inspect} to contain a #{name} result"
  end

  def assert_counter_logged(name)
    refute_empty counters.select {|c| c.name = name }, "Expected #{counters.inspect} to contain a #{name} result"
  end

  def gauges
    Harness::NullAdapter.gauges
  end

  def counters
    Harness::NullAdapter.counters
  end
end
