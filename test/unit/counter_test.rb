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
end
