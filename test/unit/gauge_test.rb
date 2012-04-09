require 'test_helper'

class GaugeTest < MiniTest::Unit::TestCase
  def setup
    @gauge = Harness::Gauge.new
  end

  def test_has_a_name_attribute
    assert @gauge.respond_to?(:name)
    assert @gauge.respond_to?(:name=)
  end

  def test_has_a_source_attribute
    assert @gauge.respond_to?(:source)
    assert @gauge.respond_to?(:source=)
  end

  def test_has_a_time_attribute
    assert @gauge.respond_to?(:time)
    assert @gauge.respond_to?(:time=)
  end

  def test_has_a_value_attribute
    assert @gauge.respond_to?(:value)
    assert @gauge.respond_to?(:value=)
  end

  def test_sets_name_from_event
    event = ActiveSupport::Notifications::Event.new "name", Time.now, Time.now, nil, {}

    gauge = Harness::Gauge.from_event event

    assert_equal "name", gauge.name
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

    assert_in_delta 1, 0.01, gauge.value
  end

  def test_initializes_time_if_not_set
    gauge = Harness::Gauge.new

    assert gauge.time
  end
end
