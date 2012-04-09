require 'test_helper'

class CounterTest < MiniTest::Unit::TestCase
  def setup
    @counter = Harness::Counter.new
  end

  def test_has_a_name_attribute
    assert @counter.respond_to?(:name)
    assert @counter.respond_to?(:name=)
  end

  def test_has_a_source_attribute
    assert @counter.respond_to?(:source)
    assert @counter.respond_to?(:source=)
  end

  def test_has_a_time_attribute
    assert @counter.respond_to?(:time)
    assert @counter.respond_to?(:time=)
  end

  def test_has_a_value_attribute
    assert @counter.respond_to?(:value)
    assert @counter.respond_to?(:value=)
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
end
