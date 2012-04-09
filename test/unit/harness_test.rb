require 'test_helper'

class HarnessModuleTest < MiniTest::Unit::TestCase
  def test_can_set_the_adapter_with_a_symbol
    Harness.config.adapter = :null

    assert_equal Harness::NullAdapter, Harness.config.adapter
  end

  def test_can_set_the_adapter_with_a_class
    Harness.config.adapter = Harness::NullAdapter

    assert_equal Harness::NullAdapter, Harness.config.adapter
  end
end
