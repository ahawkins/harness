events = %w(render_template render_partial)

regex = %r{#{events.join("|")}.action_view}

ActiveSupport::Notifications.subscribe regex do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  gauge = Harness::Gauge.from_event event
  gauge.log
end

