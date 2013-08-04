events = %w(receive deliver)

events.each do |name|
  ActiveSupport::Notifications.subscribe "#{name}.action_mailer" do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    timer = Harness::Timer.new "action_mailer.#{name}", event.duration
    timer.log
  end
end
