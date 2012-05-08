require 'test_helper'

class ActionViewIntegration < IntegrationTest
  def test_logs_render_template
    instrument "render_template"

    assert_gauge_logged "render_template.action_view"
  end

  def test_logs_render_partial
    instrument "render_partial"

    assert_gauge_logged "render_partial.action_view"
  end

  def test_skips_internal_partial_events
    instrument "!render_partial"

    refute_gauge_logged "!render_partial.action_view"
  end

  def test_skips_internal_template_events
    instrument "!render_template"

    refute_gauge_logged "!render_template.action_view"
  end

  private
  def instrument(event)
    ActiveSupport::Notifications.instrument "#{event}.action_view"
  end
end
