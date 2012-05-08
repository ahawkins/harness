events = %w(write_fragment read_fragment expire_fragment write_page expire_page process_action send_file)

events.each do |name|
  ActiveSupport::Notifications.subscribe "#{name}.action_controller" do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    gauge = Harness::Gauge.from_event event
    gauge.log
  end
end
