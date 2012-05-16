require 'test_helper'

class StatsdAdapterTest < MiniTest::Unit::TestCase
  def setup
    @adapter = Harness::StatsdAdapter

    @gauge = Harness::Gauge.new
    @gauge.id = "fake-gauge"
    @gauge.name = "Fake Gauge"
    @gauge.source = "minitest"
    @gauge.time = Time.now
    @gauge.value = 55

    @counter = Harness::Counter.new
    @counter.id = "fake-counter"
    @counter.name = "Fake Counter"
    @counter.source = "minitest"
    @counter.time = Time.now
    @counter.value = 55
    @counter.units = :bytes

    Harness::StatsdAdapter.config.host = host
    Harness::StatsdAdapter.config.port = port
    Harness.config.namespace = nil
  end

  def test_gauge_is_logged
    backend = MiniTest::Mock.new
    backend.expect(:gauge, nil, "fake.counter")

    @adapter.backend = backend
    assert @adapter.log_gauge(@gauge)
    assert backend.verify
  end

  def test_gauge_is_logged_with_namespace
    Harness.config.namespace = :foo
    backend = MiniTest::Mock.new
    backend.expect(:gauge, nil, "foo.fake.counter")

    @adapter.backend = backend
    assert @adapter.log_gauge(@gauge)
    assert backend.verify
  end

  private
  def host
    'localhost'
  end

  def port
    1337
  end
end
