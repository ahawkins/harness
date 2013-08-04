events = %w(write_fragment read_fragment expire_fragment process_action send_file)

events.each do |name|
  ActiveSupport::Notifications.subscribe "#{name}.action_controller" do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    timer = Harness::Timer.new "action_controller.#{name}", event.duration
    timer.log

    if name == 'process_action'
      counter = Harness::Counter.new "action_controller.#{name}"
      counter.log
    end
  end
end
