require 'test_helper'

class LibratoAdapterTest < MiniTest::Unit::TestCase
  def setup
    @adapter = Harness::LibratoAdapter.new

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

    Harness::LibratoAdapter.config.email = email
    Harness::LibratoAdapter.config.token = token
    Harness.config.namespace = nil
  end

  def test_gauge_is_logged
    json = {
      :gauges => [{
        :name => @gauge.id,
        :display_name => @gauge.name,
        :value => @gauge.value,
        :measure_time => @gauge.time.to_i,
        :source => @gauge.source,
        :attributes => { :display_units_short => @gauge.units }
      }]
    }.to_json

    expected_request = stub_request(:post, "https://#{email}:#{token}@metrics-api.librato.com/v1/metrics").
      with(:body => json, :headers => {"Content-Type" => "application/json"}).
      to_return(:status => 200)

    assert @adapter.log_gauge(@gauge)
    assert_requested expected_request
  end

  def test_gauge_is_logged_with_namespace
    Harness.config.namespace = :foo

    json = {
      :gauges => [{
        :name => "#{@gauge.id}.foo",
        :display_name => @gauge.name,
        :value => @gauge.value,
        :measure_time => @gauge.time.to_i,
        :source => @gauge.source,
        :attributes => { :display_units_short => @gauge.units }
      }]
    }.to_json

    expected_request = stub_request(:post, "https://#{email}:#{token}@metrics-api.librato.com/v1/metrics").
      with(:body => json, :headers => {"Content-Type" => "application/json"}).
      to_return(:status => 200)

    assert @adapter.log_gauge(@gauge)
    assert_requested expected_request
  end

  def test_logging_gauge_raises_an_exception
    stub_request(:post, %r{metrics}).to_return(:status => 500, :body => "message")

    assert_raises Harness::LoggingError do
      @adapter.log_gauge @gauge
    end
  end

  def test_logging_gauge_raises_an_exception_when_id_is_too_long
    @gauge.id = "f" * 64

    assert_raises Harness::LoggingError do
      @adapter.log_gauge @gauge
    end
  end

  def test_logging_gauge_raises_an_exception_when_not_configured
    Harness::LibratoAdapter.config.email = nil
    Harness::LibratoAdapter.config.token = nil

    assert_raises RuntimeError do
      @adapter.log_gauge @gauge
    end
  end

  def test_counter_is_logged
    json = {
      :counters => [{
        :name => @counter.id,
        :display_name => @counter.name,
        :value => @counter.value,
        :measure_time => @counter.time.to_i,
        :source => @counter.source,
        :attributes => { :display_units_short => @counter.units }
      }]
    }.to_json

    expected_request = stub_request(:post, "https://#{email}:#{token}@metrics-api.librato.com/v1/metrics").
      with(:body => json, :headers => {"Content-Type" => "application/json"}).
      to_return(:status => 200)

    assert @adapter.log_counter(@counter)
    assert_requested expected_request
  end

  def test_counter_is_logged_with_namespace
    Harness.config.namespace = :foo

    json = {
      :counters => [{
        :name => "#{@counter.id}.foo",
        :display_name => @counter.name,
        :value => @counter.value,
        :measure_time => @counter.time.to_i,
        :source => @counter.source,
        :attributes => { :display_units_short => @counter.units }
      }]
    }.to_json

    expected_request = stub_request(:post, "https://#{email}:#{token}@metrics-api.librato.com/v1/metrics").
      with(:body => json, :headers => {"Content-Type" => "application/json"}).
      to_return(:status => 200)

    assert @adapter.log_counter(@counter)
    assert_requested expected_request
  end

  def test_logging_counter_raises_an_exception
    stub_request(:post, %r{metrics}).to_return(:status => 500, :body => "message")

    assert_raises Harness::LoggingError do
      @adapter.log_counter @counter
    end
  end

  def test_logging_counter_raises_an_exception_when_not_configured
    Harness::LibratoAdapter.config.email = nil
    Harness::LibratoAdapter.config.token = nil

    assert_raises RuntimeError do
      @adapter.log_counter @counter
    end
  end

  def test_logging_counter_raises_an_exception_when_id_is_too_long
    @counter.id = "f" * 64

    assert_raises Harness::LoggingError do
      @adapter.log_counter @counter
    end
  end

  private
  def email
    'example@example.com'
  end

  def token
    'a-complete-api-token'
  end
end
