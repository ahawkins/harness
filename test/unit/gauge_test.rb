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
end
