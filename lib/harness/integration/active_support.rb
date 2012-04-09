events = %w(cache_read cache_generate cache_fetch_hit cache_write cache_delete)

regex = %r{#{events.join("|")}.active_support}

ActiveSupport::Notifications.subscribe regex do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  gauge = Harness::Gauge.from_event event
  gauge.log
end
