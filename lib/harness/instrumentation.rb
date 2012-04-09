ActiveSupport::Notifications.subscribe %r{.+} do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  if event.payload[:gauge]
    Harness.log Harness::Gauge.from_event(event)
  elsif event.payload[:counter]
    Harness.log Harness::Counter.from_event(event)
  end
end
