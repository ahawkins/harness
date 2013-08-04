require_relative '../test_helper'

class ActionViewIntegration < MiniTest::Unit::TestCase
  def test_logs_render_template
    instrument "render_template"

    assert_timer "action_view.render_template"
  end

  def test_logs_render_partial
    instrument "render_partial"

    assert_timer "action_view.render_partial"
  end

  def test_skips_internal_partial_events
    instrument "!render_partial"

    assert_empty timers
  end

  def test_skips_internal_template_events
    instrument "!render_template"

    assert_empty timers
  end

  private
  def instrument(event)
    super "#{event}.action_view", { }
  end
end
