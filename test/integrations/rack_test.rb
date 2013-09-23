require_relative '../test_helper'

class RackInstrumenterTest < MiniTest::Unit::TestCase
  def app
    @app ||= lambda { |env| [200, { }, [ ]] }
  end

  def test_reports_total_run_time
    instrumentor = Harness::RackInstrumenter.new app
    instrumentor.call({})

    assert_timer 'rack.request.all'
  end

  def test_counts_requests_by_status_code
    instrumentor = Harness::RackInstrumenter.new app
    instrumentor.call({})

    assert_increment 'rack.request.200'
  end

  def test_accepts_a_namespace
    instrumentor = Harness::RackInstrumenter.new app, 'foo'
    instrumentor.call({})

    assert_increment 'rack.request.foo.200'
    assert_timer 'rack.request.foo.all'
  end
end
