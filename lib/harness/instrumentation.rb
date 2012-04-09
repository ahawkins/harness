ActiveSupport::Notifications.subscribe %r{.+} do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  if event.payload[:gauge]
    Harness::Gauge.from_event(event).log
  elsif event.payload[:counter]
    Harness::Counter.from_event(event).log
  end
end
