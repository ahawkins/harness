ActiveSupport::Notifications.subscribe %r{.+} do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  next if event.payload[:exception]

  Harness::Timer.from_event(event).log if event.payload[:timer]
  Harness::Counter.from_event(event).log if event.payload[:counter]
end
