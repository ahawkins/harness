require_relative '../test_helper'
require 'active_record'
require 'harness/integration/active_record'

class ActiveRecordIntegrationTest < MiniTest::Unit::TestCase
  def sql
    'fake-sql'
  end

  def test_reports_queries_as_counters_and_timers
    instrument 'sql.active_record', name: 'foo', sql: sql

    assert_increment "active_record.query"
    assert_timer "active_record.query"
  end

  def test_reports_selects_as_reads
    instrument 'sql.active_record', name: 'SELECT', sql: sql

    assert_timer "active_record.read"
    assert_increment "active_record.read"
  end

  def test_reports_select_as_own_stat
    instrument 'sql.active_record', name: 'SELECT', sql: sql

    assert_timer "active_record.select"
    assert_increment "active_record.select"
  end

  def test_reports_inserts_as_writes
    instrument 'sql.active_record', name: 'INSERT', sql: sql

    assert_timer "active_record.write"
    assert_increment "active_record.write"
  end

  def test_reports_inserts_as_own_stat
    instrument 'sql.active_record', name: 'INSERT', sql: sql

    assert_timer "active_record.insert"
    assert_increment "active_record.insert"
  end

  def test_reports_updates_as_writes
    instrument 'sql.active_record', name: 'UPDATE', sql: sql

    assert_timer "active_record.write"
    assert_increment "active_record.write"
  end

  def test_reports_updates_as_own_stat
    instrument 'sql.active_record', name: 'UPDATE', sql: sql

    assert_timer "active_record.update"
    assert_increment "active_record.update"
  end

  def test_reports_deletes_as_writes
    instrument 'sql.active_record', name: 'DELETE', sql: sql

    assert_timer "active_record.write"
    assert_increment "active_record.write"
  end

  def test_reports_deletes_as_own_stat
    instrument 'sql.active_record', name: 'DELETE', sql: sql

    assert_timer "active_record.delete"
    assert_increment "active_record.delete"
  end
end
