require 'test_helper'

class MeasurementTest < MiniTest::Unit::TestCase
  def setup
    @measurement = Harness::Measurement.new
  end

  def test_has_a_name_attribute
    assert @measurement.respond_to?(:name)
    assert @measurement.respond_to?(:name=)
  end

  def test_has_a_source_attribute
    assert @measurement.respond_to?(:source)
    assert @measurement.respond_to?(:source=)
  end

  def test_has_a_time_attribute
    assert @measurement.respond_to?(:time)
    assert @measurement.respond_to?(:time=)
  end

  def test_has_a_value_attribute
    assert @measurement.respond_to?(:value)
    assert @measurement.respond_to?(:value=)
  end

  def test_has_a_description_attribute
    assert @measurement.respond_to?(:description)
    assert @measurement.respond_to?(:description=)
  end

  def test_has_a_display_attribute
    assert @measurement.respond_to?(:display)
    assert @measurement.respond_to?(:display=)
  end

  def test_initializes_time
    assert @measurement.time
  end

  def test_initializes_units
    assert_equal :milliseconds, @measurement.units
  end
end
