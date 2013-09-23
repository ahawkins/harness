require_relative '../test_helper'
require 'sequel'
require 'harness/integration/sequel'

class SequelIntegrationTest < MiniTest::Unit::TestCase
  attr_reader :db

  def setup
    super

    @db = Sequel.sqlite

    db.create_table :items do
      primary_key :id
      String :name
      Float :price
    end

    counters.clear
    increments.clear
    gauges.clear
  end

  def test_reports_queries_as_counters_and_timers
    db[:items].all
    assert_timer "sequel.query"
  end

  def test_reports_selects_as_reads
    db[:items].all
    assert_timer "sequel.read"
  end

  def test_reports_select_as_own_stat
    db[:items].all
    assert_timer "sequel.select"
  end

  def test_reports_inserts_as_writes
    db[:items].insert name: 'abc', price: 5
    assert_timer "sequel.write"
  end

  def test_reports_inserts_as_own_stat
    db[:items].insert name: 'test', price: 5
    assert_timer "sequel.insert"
  end

  def test_reports_updates_as_writes
    db[:items].update name: 'abc', price: 5
    assert_timer "sequel.write"
  end

  def test_reports_updates_as_own_stat
    db[:items].update name: 'test', price: 5
    assert_timer "sequel.update"
  end

  def test_reports_deletes_as_writes
    db[:items].delete
    assert_timer "sequel.write"
  end

  def test_reports_deletes_as_own_stat
    db[:items].delete
    assert_timer "sequel.delete"
  end
end
