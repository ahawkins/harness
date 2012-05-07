ActiveSupport::Notifications.subscribe %r{.+} do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  Harness::Gauge.from_event(event).log if event.payload[:gauge]
  if event.payload[:counter] && !event.payload[:exception]
    Harness::Counter.from_event(event).log
  end
end
