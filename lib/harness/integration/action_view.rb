events = %w(render_template render_partial)

events.each do |name|
  ActiveSupport::Notifications.subscribe "#{name}.action_view" do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    gauge = Harness::Gauge.from_event event
    gauge.log
  end
end
