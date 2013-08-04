events = %w(serializable_hash associations)

events.each do |name|
  ActiveSupport::Notifications.subscribe %r{^#{name}.*\.serializer$} do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    parts = event.name.split '.'
    namespace = parts.pop
    name = "#{namespace}.#{parts.join('.')}"
    timer = Harness::Timer.new name, event.duration
    timer.log
  end
end
