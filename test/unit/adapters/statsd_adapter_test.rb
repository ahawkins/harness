require 'test_helper'
require 'ostruct'

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
    @counter.value = 1337
    @counter.units = :bytes

    @backend = MiniTest::Mock.new
    @backend.expect :host, 'foo'
    @backend.expect :port, 'bar'

    Harness::StatsdAdapter.config.backend = @backend
    Harness.config.namespace = nil
  end

  def test_gauge_is_logged
    @backend.expect :gauge, true, [String, 55] 

    assert @adapter.log_gauge(@gauge)
    assert @backend.verify
  end

  def test_logging_gauge_raises_an_exception_when_not_configured
    @backend.expect :host, nil
    @backend.expect :port, nil

    assert_raises RuntimeError do
      @adapter.log_gauge @gauge
    end
  end

  def test_counter_is_logged
    @backend.expect :increment, true, [String, 1337]

    assert @adapter.log_counter(@counter)
    assert @backend.verify
  end

  def test_logging_counter_raises_an_exception_when_not_configured
    @backend.expect :host, nil
    @backend.expect :port, nil

    assert_raises RuntimeError do
      @adapter.log_counter @counter
    end
  end

  def test_sanitize_removes_special_chars
    assert @adapter.sanitize('t-est/123') == 't.est.123'
  end

  def test_sanitize_adds_namespace
    Harness.config.namespace = :foo
    assert @adapter.sanitize('test-harr-harr') == 'foo.test.harr.harr'
  end
end
