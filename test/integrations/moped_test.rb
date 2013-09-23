require_relative '../test_helper'
require 'moped'
require 'harness/integration/moped'

class MopedIntegrationTest < MiniTest::Unit::TestCase
  attr_reader :moped

  def setup
    super

    @moped = Moped::Session.new(["127.0.0.1:27017"])
    moped.use "harness_test"
  end

  def test_reports_queries_as_counters_and_timers
    moped[:items].find.first
    assert_timer "moped.operation"
  end

  def test_reports_selects_as_reads
    moped[:items].find.first
    assert_timer "moped.read"
  end

  def test_reports_select_as_own_stat
    moped[:items].find.first
    assert_timer "moped.query"
  end

  def test_reports_inserts_as_writes
    moped[:items].insert name: 'abc', price: 5
    assert_timer "moped.query"
  end

  def test_reports_inserts_as_own_stat
    moped[:items].insert name: 'test', price: 5
    assert_timer "moped.insert"
  end

  def test_reports_updates_as_writes
    moped[:items].find.update name: 'abc', price: 5
    assert_timer "moped.write"
  end

  def test_reports_updates_as_own_stat
    moped[:items].find.update name: 'test', price: 5
    assert_timer "moped.update"
  end

  def test_reports_deletes_as_writes
    moped[:items].insert name: 'test', price: 5
    timers.clear

    moped[:items].find.remove
    assert_timer "moped.write"
  end

  def test_reports_deletes_as_own_stat
    moped[:items].find.remove
    assert_timer "moped.remove"
  end
end
