require_relative '../test_helper'

class RackInstrumenterTest < MiniTest::Unit::TestCase
  def app
    @app ||= lambda { |env| [200, { }, [ ]] }
  end

  def test_reports_total_run_time
    instrumentor = Harness::RackInstrumenter.new app
    instrumentor.call({})

    assert_timer 'rack.request'
  end

  def test_counts_requests_per_second
    instrumentor = Harness::RackInstrumenter.new app
    instrumentor.call({})

    assert_increment 'rack.request'
  end

  def test_counts_requests_by_status_code

  end
end
