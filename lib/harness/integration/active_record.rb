ActiveSupport::Notifications.subscribe "sql.active_record" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  op = event.payload[:name]

  next if op == 'SCHEMA' || op == 'EXPLAIN'

  Harness.increment 'active_record.query'
  Harness.timing 'active_record.query', event.duration

  case op
  when 'SELECT'
    Harness.increment 'active_record.select'
    Harness.timing 'active_record.select', event.duration
    Harness.increment 'active_record.read'
    Harness.timing 'active_record.read', event.duration
  when 'UPDATE'
    Harness.increment 'active_record.update'
    Harness.timing 'active_record.update', event.duration
    Harness.increment 'active_record.write'
    Harness.timing 'active_record.write', event.duration
  when 'INSERT'
    Harness.increment 'active_record.insert'
    Harness.timing 'active_record.insert', event.duration
    Harness.increment 'active_record.write'
    Harness.timing 'active_record.write', event.duration
  when 'DELETE'
    Harness.increment 'active_record.delete'
    Harness.timing 'active_record.delete', event.duration
    Harness.increment 'active_record.write'
    Harness.timing 'active_record.write', event.duration
  end
end
