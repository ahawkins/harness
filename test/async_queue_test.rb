require_relative 'test_helper'

class AsyncQueueTest < MiniTest::Unit::TestCase
  attr_reader :queue, :collector

  class NullQueue
    def push(*)

    end
  end

  def setup
    super
    Harness.config.queue = NullQueue.new

    @collector = Harness::FakeCollector.new
    @queue = Harness::AsyncQueue.new Queue.new, collector
    assert queue.up?, 'Precondition: consumer not running'
  end

  def teardown
    queue.stop
    super
  end

  def test_proceses_queue_after_instantiating
    q = Queue.new
    q << [:gauge, ['foo', 5]]

    @queue = Harness::AsyncQueue.new q, collector

    sleep 0.1

    assert queue.up?, 'Queue should be working'

    assert_gauge 'foo'
  end

  def test_uses_consumer_thread_to_not_block_the_main_thread
    queue.push [:gauge, ['foo', 5]]

    sleep 0.1

    assert queue.up?, 'Queue should be working'

    assert_gauge 'foo'
  end

  def test_use_configured_collector_by_default
    Harness.config.collector = collector

    @queue = Harness::AsyncQueue.new

    queue.push [:gauge, ['foo', 5]]

    sleep 0.1

    assert queue.up?, 'Queue should be working'

    assert_gauge 'foo'
  end

  def test_consumer_can_be_stopped
    assert queue.up?, 'Consumer must be alive'
    queue.stop
    sleep 0.1
    refute queue.up?, 'Consumer should be killed'
  end
end
