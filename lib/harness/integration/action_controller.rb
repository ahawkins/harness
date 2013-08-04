events = %w(write_fragment read_fragment expire_fragment process_action send_file)

events.each do |name|
  ActiveSupport::Notifications.subscribe "#{name}.action_controller" do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)

    Harness.timing "action_controller.#{name}", event.duration
    Harness.increment "action_controller.#{name}" if name == 'process_action'
  end
end
