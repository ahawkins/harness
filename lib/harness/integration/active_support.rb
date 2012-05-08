events = %w(cache_read cache_generate cache_fetch_hit cache_write cache_delete)

events.each do |name|
  ActiveSupport::Notifications.subscribe "#{name}.active_support" do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    gauge = Harness::Gauge.from_event event
    gauge.log
  end
end
