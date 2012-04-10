require 'test_helper'

class CounterTest < MiniTest::Unit::TestCase
  def setup
    @counter = Harness::Counter.new
  end

  def test_sets_name_from_event
    event = ActiveSupport::Notifications::Event.new "name", Time.now, Time.now, nil, {}

    counter = Harness::Counter.from_event event

    assert_equal "name", counter.name
  end

  def tests_sets_source_from_event_payload
    event = ActiveSupport::Notifications::Event.new "name", Time.now, Time.now, nil, :counter => { :source => 'box1' }

    counter = Harness::Counter.from_event event

    assert_equal "box1", counter.source
  end

  def test_sets_value_from_event_payload
    base = Time.now

    event = ActiveSupport::Notifications::Event.new "name", base - 1, Time.now, nil, :counter => {:value => 5 }

    counter = Harness::Counter.from_event event

    assert_equal 5, counter.value
  end

  def test_sets_value_from_event_payload_with_number
    base = Time.now

    event = ActiveSupport::Notifications::Event.new "name", base - 1, Time.now, nil, :counter => 5

    counter = Harness::Counter.from_event event

    assert_equal 5, counter.value
  end

  def test_sets_description_from_event
    base = Time.now

    event = ActiveSupport::Notifications::Event.new "name", base - 1, Time.now, nil, :counter => { :description => 'foo' }

    counter = Harness::Counter.from_event event

    assert_equal 'foo', counter.description
  end

  def test_sets_display_name_from_event
    event = ActiveSupport::Notifications::Event.new "name", Time.now, Time.now, nil, :counter => { :display => 'Box #1' }

    counter = Harness::Counter.from_event event

    assert_equal "Box #1", counter.display
  end
end
