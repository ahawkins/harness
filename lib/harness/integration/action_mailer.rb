events = %w(receive deliver)

events.each do |name|
  ActiveSupport::Notifications.subscribe "#{name}.action_mailer" do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    Harness.timing "action_mailer.#{name}", event.duration
  end
end
