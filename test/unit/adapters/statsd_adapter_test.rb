require 'test_helper'
require 'ostruct'

class StatsdAdapterTest < MiniTest::Unit::TestCase
  def setup
    @adapter = Harness::StatsdAdapter.new

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
    Harness.config.namespace = nil
  end

  def test_gauge_is_logged
    mock_backend = MiniTest::Mock.new
    mock_backend.expect :host, 'foo'
    mock_backend.expect :port, 'bar'

    Harness::StatsdAdapter.config.backend = mock_backend
    mock_backend.expect :gauge, true, [String, 55] 

    assert @adapter.log_gauge(@gauge)
    assert mock_backend.verify
  end

  def test_logging_gauge_raises_an_exception_when_not_configured
    mock_backend = MiniTest::Mock.new
    mock_backend.expect :host, nil
    mock_backend.expect :port, nil

    Harness::StatsdAdapter.config.backend = mock_backend
    mock_backend.expect :gauge, true, [String, 55] 

    assert_raises RuntimeError do
      @adapter.log_gauge @gauge
    end
  end

  def test_counter_is_logged
    mock_backend = MiniTest::Mock.new
    mock_backend.expect :host, 'foo'
    mock_backend.expect :port, 'bar'

    Harness::StatsdAdapter.config.backend = mock_backend
    mock_backend.expect :increment, true, [String, 1337]

    assert @adapter.log_counter(@counter)
    assert mock_backend.verify
  end

  def test_logging_counter_raises_an_exception_when_not_configured
    mock_backend = MiniTest::Mock.new
    mock_backend.expect :host, nil
    mock_backend.expect :port, nil

    Harness::StatsdAdapter.config.backend = mock_backend

    assert_raises RuntimeError do
      @adapter.log_counter @counter
    end
  end
end
