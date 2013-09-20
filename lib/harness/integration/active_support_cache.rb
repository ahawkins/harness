ActiveSupport::Notifications.subscribe "cache_read.active_support" do |*args|
  payload = args.last
  next if payload[:super_operation] == :fetch

  if payload[:hit]
    Harness.increment 'cache.hit'
  else
    Harness.increment 'cache.miss'
  end
end

ActiveSupport::Notifications.subscribe "cache_fetch_hit.active_support" do |*args|
  Harness.increment 'cache.hit'
end

ActiveSupport::Notifications.subscribe "cache_generate.active_support" do |*args|
  Harness.increment 'cache.miss'
end
