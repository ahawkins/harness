events = %w(receive deliver)

events.each do |name|
  ActiveSupport::Notifications.subscribe "#{name}.action_mailer" do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    gauge = Harness::Gauge.from_event event
    gauge.log
  end
end
