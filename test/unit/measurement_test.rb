require 'test_helper'

class MeasurementTest < MiniTest::Unit::TestCase
  def setup
    @measurement = Harness::Measurement.new
  end

  def test_has_an_id_attribute
    assert @measurement.respond_to?(:id)
    assert @measurement.respond_to?(:id=)
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

  def test_has_a_name_attribute
    assert @measurement.respond_to?(:name)
    assert @measurement.respond_to?(:name=)
  end

  def test_initializes_time
    assert @measurement.time
  end

  def test_can_take_a_string_time
    @measurement.time = "2010-10-1T15:15:15Z"

    assert_equal DateTime.parse("2010-10-1T15:15:15Z"), @measurement.time
  end

  def test_can_take_an_integer_time
    time = Time.now

    @measurement.time = time.to_i

    assert_equal time.to_i, @measurement.time.to_i
  end

  def test_can_take_a_time
    time = Time.now

    @measurement.time = time

    assert_equal time, @measurement.time
  end

  def test_attributes
    hash = @measurement.attributes

    assert hash.has_key?(:id)
    assert hash.has_key?(:name)
    assert hash.has_key?(:source)
    assert hash.has_key?(:time)
    assert hash.has_key?(:units)
    assert hash.has_key?(:value)
  end
end
