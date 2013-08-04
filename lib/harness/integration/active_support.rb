events = %w(cache_read cache_generate cache_fetch_hit cache_write cache_delete)

events.each do |name|
  ActiveSupport::Notifications.subscribe "#{name}.active_support" do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    timer = Harness::Timer.new "active_support.#{name}", event.duration
    timer.log

    counter = Harness::Counter.new "active_support.#{name}"
    counter.log
  end
end
