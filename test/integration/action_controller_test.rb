require 'test_helper'

class ActionControllerIntegration < MiniTest::Unit::TestCase
  def setup
    Harness.adapter = :null
    gauges.clear
  end

  def test_logs_write_fragment
    instrument "write_fragment"

    assert_gauge_logged "write_fragment.action_controller"
  end

  def test_logs_read_fragment
    instrument "read_fragment"

    assert_gauge_logged "read_fragment.action_controller"
  end

  def test_logs_expire_fragment
    instrument "expire_fragment"

    assert_gauge_logged "expire_fragment.action_controller"
  end

  def test_logs_write_page
    instrument "write_page"

    assert_gauge_logged "write_page.action_controller"
  end

  def test_logs_expire_page
    instrument "expire_page"

    assert_gauge_logged "expire_page.action_controller"
  end

  def test_logs_process_action
    instrument "process_action"

    assert_gauge_logged "process_action.action_controller"
  end

  def test_logs_send_file
    instrument "send_file"

    assert_gauge_logged "send_file.action_controller"
  end

  private
  def instrument(event)
    ActiveSupport::Notifications.instrument "#{event}.action_controller" do |*args|
      # nada
    end
  end

  def assert_gauge_logged(name)
    refute_empty gauges.select {|g| g.name = name }, "Expected #{gauges.inspect} to contain a #{name} result"
  end

  def gauges
    Harness::NullAdapter.gauges
  end
end
