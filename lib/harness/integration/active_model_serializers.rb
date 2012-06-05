events = %w(serializable_hash associations)

events.each do |name|
  ActiveSupport::Notifications.subscribe %r{^#{name}.*\.serializer$} do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    gauge = Harness::Gauge.from_event event
    gauge.log
  end
end
