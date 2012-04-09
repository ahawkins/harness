require 'test_helper'

class HarnessTest < MiniTest::Unit::TestCase
  def test_can_set_the_adapter_with_a_symbol
    Harness.adapter = :null

    assert  Harness.adapter
  end

  def test_can_set_the_adapter_with_a_class
    Harness.adapter = Harness::NullAdapter

    assert_equal Harness::NullAdapter, Harness.adapter
  end
end
