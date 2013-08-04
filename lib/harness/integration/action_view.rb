events = %w(render_template render_partial)

events.each do |name|
  ActiveSupport::Notifications.subscribe "#{name}.action_view" do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    Harness.timing "action_view.#{name}", event.duration
  end
end
