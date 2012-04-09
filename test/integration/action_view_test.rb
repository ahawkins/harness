require 'test_helper'

class ActionViewIntegration < MiniTest::Unit::TestCase
  def setup
    Harness.adapter = :null
    gauges.clear
  end

  def test_logs_render_template
    instrument "render_template"

    assert_gauge_logged "render_template.action_view"
  end

  def test_logs_render_partial
    instrument "render_partial"

    assert_gauge_logged "render_partial.action_view"
  end

  private
  def instrument(event)
    ActiveSupport::Notifications.instrument "#{event}.action_view" do |*args|
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
