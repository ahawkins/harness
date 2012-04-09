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

  def test_uses_method_missing_to_configure_adapters
    Harness.config.librato.email = 'foo'

    assert_equal 'foo', Harness.config.librato.email
  end

  def test_blows_up_when_calling_an_unknown_adapter
    assert_raises NoMethodError do
      Harness.config.foo_bar
    end
  end
end
