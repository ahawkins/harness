require 'active_support/core_ext/module'

module Sequel
  class Database
    def log_yield_with_instrument(sql, args = nil, &block)
      ActiveSupport::Notifications.instrument "sequel.query", sql: sql, timer: true, counter: true do
        log_yield_without_instrument sql, args, &block
      end
    end
    alias_method_chain :log_yield, :instrument
  end
end

ActiveSupport::Notifications.subscribe "sequel.query" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  sql = event.payload.fetch :sql
  op = sql[0..5]

  case op
  when 'SELECT'
    Harness.increment 'sequel.select'
    Harness.timing 'sequel.select', event.duration
    Harness.increment 'sequel.read'
    Harness.timing 'sequel.read', event.duration
  when 'UPDATE'
    Harness.increment 'sequel.update'
    Harness.timing 'sequel.update', event.duration
    Harness.increment 'sequel.write'
    Harness.timing 'sequel.write', event.duration
  when 'INSERT'
    Harness.increment 'sequel.insert'
    Harness.timing 'sequel.insert', event.duration
    Harness.increment 'sequel.write'
    Harness.timing 'sequel.write', event.duration
  when 'DELETE'
    Harness.increment 'sequel.delete'
    Harness.timing 'sequel.delete', event.duration
    Harness.increment 'sequel.write'
    Harness.timing 'sequel.write', event.duration
  end
end
