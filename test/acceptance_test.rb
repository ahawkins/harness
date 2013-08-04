require_relative 'test_helper'

class ActiveSupportTestCase < MiniTest::Unit::TestCase
  def test_timers_are_logged
    instrument 'test', timer: true

    refute_empty timers
    timer = timers.first
    assert_equal 'test', timer.name
    assert_kind_of Float, timer.ms
  end

  def test_timer_name_can_be_customized
    instrument 'test', timer: 'foo'

    refute_empty timers
    timer = timers.first
    assert_equal 'foo', timer.name
  end

  def test_timer_rate_can_be_customized
    instrument 'test', timer: { rate: 0.5, name: 'foo', value: 5 }

    refute_empty timers
    timer = timers.first
    assert_equal 0.5, timer.rate
    assert_equal 'foo', timer.name
  end

  def test_passed_value_does_not_override_blocks
    instrument 'test', timer: { rate: 0.5, name: 'foo', value: 5 }

    refute_empty timers
    timer = timers.first
    refute_equal 5, timer.value
  end

  def test_does_not_log_timers_on_exception
    begin
      instrument 'test', timer: true do
        raise
      end
    rescue
    end

    assert_empty timers
  end

  def test_counters_with_no_value_are_treated_as_increments
    instrument 'test', counter: true

    refute_empty increments
    counter = increments.first
    assert_equal 'test', counter.name
  end

  def test_counters_can_have_explicit_values
    instrument 'test', counter: 5

    refute_empty counters
    counter = counters.first
    assert_equal 'test', counter.name
  end

  def test_counter_name_can_be_customized
    instrument 'test', counter: 'foo'

    refute_empty increments
    counter = increments.first
    assert_equal 'foo', counter.name
  end

  def test_counter_rate_can_be_customized
    instrument 'test', counter: { rate: 0.5, name: 'foo', value: 5 }

    refute_empty counters
    counter = counters.first
    assert_equal 0.5, counter.rate
    assert_equal 'foo', counter.name
    assert_equal 5, counter.value
  end

  def test_does_not_log_counters_on_exceptions
    begin
      instrument 'test', counter: true do
        raise
      end
    rescue
    end

    assert_empty counters
  end
end
