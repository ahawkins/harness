ActiveSupport::Notifications.subscribe "sql.active_record" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  op = event.payload[:name]

  next if op == 'SCHEMA' || op == 'EXPLAIN'

  Harness.increment 'active_record.query'
  Harness.timing 'active_record.query', event.duration

  case op
  when 'SELECT'
    Harness.timing 'active_record.select', event.duration
    Harness.timing 'active_record.read', event.duration
  when 'UPDATE'
    Harness.timing 'active_record.update', event.duration
    Harness.timing 'active_record.write', event.duration
  when 'INSERT'
    Harness.timing 'active_record.insert', event.duration
    Harness.timing 'active_record.write', event.duration
  when 'DELETE'
    Harness.timing 'active_record.delete', event.duration
    Harness.timing 'active_record.write', event.duration
  end
end
