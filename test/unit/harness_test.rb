require 'test_helper'

class HarnessModuleTest < MiniTest::Unit::TestCase
  def test_can_set_the_adapter_with_a_symbol
    Harness.config.adapter = :memory

    assert_kind_of Harness::MemoryAdapter, Harness.config.adapter
  end

  def test_can_set_the_adapter_with_an_adapter_instance
    Harness.config.adapter = Harness::MemoryAdapter.new

    assert_kind_of Harness::MemoryAdapter, Harness.config.adapter
  end

  def test_can_set_the_queue_with_a_symbol
    Harness.config.queue = :synchronous

    assert_kind_of Harness::SynchronousQueue, Harness.config.queue
  end

  def test_can_set_the_queue_with_misspelled_symbol_for_backward_compat
    Harness.config.queue = :syncronous

    assert_kind_of Harness::SynchronousQueue, Harness.config.queue
  end

  def test_can_set_the_queue_with_a_queue_instance
    Harness.config.queue = Harness::SynchronousQueue.new

    assert_kind_of Harness::SynchronousQueue, Harness.config.queue
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
