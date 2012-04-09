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

  private
  def instrument(event)
    ActiveSupport::Notifications.instrument "#{event}.action_view" do |*args|
      # nada
    end
  end
end
