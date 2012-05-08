ActiveSupport::Notifications.subscribe %r{.+} do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  unless event.payload[:exception]
    Harness::Gauge.from_event(event).log if event.payload[:gauge]
    Harness::Counter.from_event(event).log if event.payload[:counter]
  end
end
