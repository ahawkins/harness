require 'test_helper'

class GaugeTest < MiniTest::Unit::TestCase
  def setup
    @gauge = Harness::Gauge.new
  end

  def test_initializes_units
    assert_equal :ms, @gauge.units
  end

  def test_sets_name_id_event
    event = ActiveSupport::Notifications::Event.new "name", Time.now, Time.now, nil, {}

    gauge = Harness::Gauge.from_event event

    assert_equal "name", gauge.id
  end

  def tests_sets_source_from_event_payload
    event = ActiveSupport::Notifications::Event.new "name", Time.now, Time.now, nil, :gauge => { :source => 'box1' }

    gauge = Harness::Gauge.from_event event

    assert_equal "box1", gauge.source
  end

  def test_sets_duration_from_event
    base = Time.now

    event = ActiveSupport::Notifications::Event.new "name", base - 1, Time.now, nil, {}

    gauge = Harness::Gauge.from_event event

    assert_in_delta 1000, 0.01, gauge.value
  end

  def test_sets_name_from_event
    base = Time.now

    event = ActiveSupport::Notifications::Event.new "name", base - 1, Time.now, nil, :gauge => { :name => 'foo' }

    gauge = Harness::Gauge.from_event event

    assert_equal 'foo', gauge.name
  end

  def test_sets_id_from_payload_if_symbol
    base = Time.now

    event = ActiveSupport::Notifications::Event.new "name", base - 1, Time.now, nil, :gauge => :foo

    gauge = Harness::Gauge.from_event event

    assert_equal 'foo', gauge.id
  end

  def test_sets_id_from_payload_if_string
    base = Time.now

    event = ActiveSupport::Notifications::Event.new "name", base - 1, Time.now, nil, :gauge => 'foo'

    gauge = Harness::Gauge.from_event event

    assert_equal 'foo', gauge.id
  end

  def test_sets_value_from_payload_if_number
    base = Time.now

    event = ActiveSupport::Notifications::Event.new "name", base - 1, Time.now, nil, :gauge => {value: 42}

    gauge = Harness::Gauge.from_event event

    assert_equal 42, gauge.value
  end

  def test_initializes_time_if_not_set
    gauge = Harness::Gauge.new

    assert gauge.time
  end
end
