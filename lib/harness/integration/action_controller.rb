events = %w(write_fragment read_fragment expire_fragment write_page expire_page process_action send_file)

regex = %r{#{events.join("|")}.action_controller}

ActiveSupport::Notifications.subscribe regex do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  gauge = Harness::Gauge.from_event event
  gauge.log
end
