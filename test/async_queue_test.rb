require_relative 'test_helper'
Thread.abort_on_exception = true

class AsyncQueueTest < MiniTest::Unit::TestCase
  def test_uses_consumer_thread_to_not_block_the_main_thread
    queue = Harness::AsyncQueue.new

    queue.push [:gauge, ['foo', 5]]

    sleep 0.1

    assert_gauge 'foo'
  end
end
