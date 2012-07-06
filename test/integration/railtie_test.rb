require 'test_helper'
require 'rails'
require 'action_controller/railtie'
require 'harness/railtie'

class TestRailsApp < Rails::Application
  config.active_support.deprecation = proc { |message, stack| }
  initialize!
end

class RailtieTest < MiniTest::Unit::TestCase
  def app
    TestRailsApp
  end

  def test_configures_instrumentation
    assert app.config.harness.instrument.action_controller
    assert app.config.harness.instrument.action_mailer
    assert app.config.harness.instrument.action_view
    refute app.config.harness.instrument.active_support
  end

  def test_configures_queue
    assert_kind_of Harness::SynchronousQueue, app.config.harness.queue
  end
end
