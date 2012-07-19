require 'test_helper'

class StathatAdapterTest < MiniTest::Unit::TestCase
  def setup
    @adapter = Harness::StathatAdapter.new

    @gauge = Harness::Gauge.new
    @gauge.id = "fake-gauge"
    @gauge.name = "Fake Gauge"
    @gauge.source = "minitest"
    @gauge.time = Time.now
    @gauge.value = "55"

    @counter = Harness::Counter.new
    @counter.id = "fake-counter"
    @counter.name = "Fake Counter"
    @counter.source = "minitest"
    @counter.time = Time.now
    @counter.value = "55"
    @counter.units = :bytes

    Harness::StathatAdapter.config.ezkey = token
    Harness.config.namespace = nil
  end

  def test_gauge_is_logged
    args = {
      :stat => @gauge.id,
      :ezkey => token,
      :value => @gauge.value,
    }

    expected_request = stub_request(:post, "https://api.stathat.com/ez").
      with(:body => args, :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}).
      to_return(:status => 200)

    assert @adapter.log_gauge(@gauge)
    assert_requested expected_request
  end

  def test_gauge_is_logged_with_namespace
    Harness.config.namespace = :foo

    args = {
      :stat => "#{@gauge.id}.foo",
      :ezkey => token,
      :value => @gauge.value,
    }

    expected_request = stub_request(:post, "https://api.stathat.com/ez").
      with(:body => args, :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}).
      to_return(:status => 200)

    assert @adapter.log_gauge(@gauge)
    assert_requested expected_request
  end

  def test_logging_gauge_raises_an_exception
    stub_request(:post, %r{stathat}).to_return(:status => 500, :body => "message")

    assert_raises Harness::LoggingError do
      @adapter.log_gauge @gauge
    end
  end

  def test_logging_gauge_raises_an_exception_when_id_is_too_long
    @gauge.id = "f" * 256

    assert_raises Harness::LoggingError do
      @adapter.log_gauge @gauge
    end
  end

  def test_logging_gauge_raises_an_exception_when_not_configured
    Harness::StathatAdapter.config.ezkey = nil

    assert_raises RuntimeError do
      @adapter.log_gauge @gauge
    end
  end

  def test_counter_is_logged
     args = {
      :stat => @counter.id,
      :ezkey => token,
      :count => @counter.value,
    }

    expected_request = stub_request(:post, "https://api.stathat.com/ez").
      with(:body => args, :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}).
      to_return(:status => 200)

    assert @adapter.log_counter(@counter)
    assert_requested expected_request
  end

  def test_counter_is_logged_with_namespace
    Harness.config.namespace = :foo

     args = {
      :stat => "#{@counter.id}.foo",
      :ezkey => token,
      :count => @counter.value,
    }

    expected_request = stub_request(:post, "https://api.stathat.com/ez").
      with(:body => args, :headers => {'Content-Type'=>'application/x-www-form-urlencoded'}).
      to_return(:status => 200)

    assert @adapter.log_counter(@counter)
    assert_requested expected_request
  end

  def test_logging_counter_raises_an_exception
    stub_request(:post, %r{stathat}).to_return(:status => 500, :body => "message")

    assert_raises Harness::LoggingError do
      @adapter.log_counter @counter
    end
  end

  def test_logging_counter_raises_an_exception_when_not_configured
    Harness::StathatAdapter.config.ezkey = nil

    assert_raises RuntimeError do
      @adapter.log_counter @counter
    end
  end

  def test_logging_counter_raises_an_exception_when_id_is_too_long
    @counter.id = "f" * 256

    assert_raises Harness::LoggingError do
      @adapter.log_counter @counter
    end
  end

  private

  def token
    'example@example.com'
  end
end