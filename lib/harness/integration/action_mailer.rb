events = %w(receive deliver)

regex = %r{#{events.join("|")}.action_mailer}

ActiveSupport::Notifications.subscribe regex do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  gauge = Harness::Gauge.from_event event
  gauge.log
end

