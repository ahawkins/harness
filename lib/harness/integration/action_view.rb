events = %w(render_template render_partial)

events.each do |name|
  ActiveSupport::Notifications.subscribe "#{name}.action_view" do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    timer = Harness::Timer.new "action_view.#{name}", event.duration
    timer.log
  end
end
