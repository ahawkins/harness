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

  def test_attributes
    hash = @measurement.attributes

    assert hash.has_key?(:id)
    assert hash.has_key?(:name)
    assert hash.has_key?(:source)
    assert hash.has_key?(:time)
    assert hash.has_key?(:units)
  end

  def test_json
    assert_equal @measurement.to_json, @measurement.attributes.to_json
  end
end
