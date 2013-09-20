require_relative 'test_helper'

class AcceptanceTest < MiniTest::Unit::TestCase
  def test_works_with_actual_statsd
    Harness.config.collector = Statsd.new
    Harness.config.queue = Harness::SynchronousQueue.new

    Harness.increment 'foo', 0.6
    Harness.decrement 'foo', 0.5
    Harness.count 'foo', 5, 0.5

    Harness.gauge 'foo', 0.5, 0.1

    Harness.timing 'foo', 0.5, 0.1

    Harness.time 'foo', 1 do
      true
    end

    Harness.instrument 'foo', 1 do
      true
    end
  end
end
