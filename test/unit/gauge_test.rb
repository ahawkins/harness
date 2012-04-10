require 'test_helper'

class GaugeTest < MiniTest::Unit::TestCase
  def setup
    @gauge = Harness::Gauge.new
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

  def test_sets_description_from_event
    base = Time.now

    event = ActiveSupport::Notifications::Event.new "name", base - 1, Time.now, nil, :gauge => { :description => 'foo' }

    gauge = Harness::Gauge.from_event event

    assert_equal 'foo', gauge.description
  end

  def test_sets_display_name_from_event
    event = ActiveSupport::Notifications::Event.new "name", Time.now, Time.now, nil, :gauge => { :display => 'Box #1' }

    gauge = Harness::Gauge.from_event event

    assert_equal "Box #1", gauge.display
  end

  def test_initializes_time_if_not_set
    gauge = Harness::Gauge.new

    assert gauge.time
  end
end
