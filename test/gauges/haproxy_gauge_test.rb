require_relative '../test_helper'

class HAProxyGaugeTest < MiniTest::Unit::TestCase
  attr_accessor :csv, :gauge

  def host ; 'example.com' ; end
  def username ; 'adam' ; end
  def password ; 'password' ; end

  def setup
    super
    @gauge = Harness::HAProxyGauge.new host, username, password
    @csv = <<-csv
pxname,svname,qcur,qmax,scur,smax,slim,stot,bin,bout,dreq,dresp,ereq,econ,eresp,wretr,wredis,status,weight,act,bck,chkfail,chkdown,lastchg,downtime,qlimit,pid,iid,sid,throttle,lbtot,tracked,type,rate,rate_lim,rate_max,check_status,check_code,check_duration,hrsp_1xx,hrsp_2xx,hrsp_3xx,hrsp_4xx,hrsp_5xx,hrsp_other,hanafail,req_rate,req_rate_max,req_tot,cli_abrt,srv_abrt,
app,FRONTEND,,,19,41,2000,1389,166416061,554877036,0,0,0,,,,,OPEN,,,,,,,,,1,1,0,,,,0,0,0,13,,,,0,100069,6995,3082,147,28,,47,75,110338,,,
    csv

    stub_request(:get, "#{username}:#{password}@#{host}/haproxy?stats;csv").to_return({
      status: 200,
      body: csv
    })
  end

  def test_measures_current_queue_depth
    log

    assert_gauge 'haproxy.app.queue.current.frontend'
  end

  def test_measures_current_maximum_queue_size
    log

    assert_gauge 'haproxy.app.queue.max.frontend'
  end

  def test_measures_current_sessions
    log

    assert_gauge 'haproxy.app.session.current.frontend'
  end

  def test_measures_max_sessions
    log

    assert_gauge 'haproxy.app.session.max.frontend'
  end

  def test_measures_session_limit
    log

    assert_gauge 'haproxy.app.session.limit.frontend'
  end

  def test_measures_session_total
    log

    assert_gauge 'haproxy.app.session.total.frontend'
  end

  def test_measures_bytes_in
    log

    assert_gauge 'haproxy.app.bytes.in.frontend'
  end

  def test_measures_bytes_out
    log

    assert_gauge 'haproxy.app.bytes.out.frontend'
  end

  def test_measures_1xxs
    log

    assert_gauge 'haproxy.app.response.1xx.frontend'
  end

  def test_measures_2xxs
    log

    assert_gauge 'haproxy.app.response.2xx.frontend'
  end

  def test_measures_3xxs
    log

    assert_gauge 'haproxy.app.response.3xx.frontend'
  end

  def test_measures_4xxs
    log

    assert_gauge 'haproxy.app.response.4xx.frontend'
  end

  def test_measures_5xxs
    log

    assert_gauge 'haproxy.app.response.5xx.frontend'
  end

  def test_measures_requests_per_second
    log

    assert_gauge 'haproxy.app.request.rate.frontend'
  end

  def test_measures_maximum_requests_per_second
    log

    assert_gauge 'haproxy.app.request.max_rate.frontend'
  end

  def test_measures_total_number_http_requests
    log

    assert_gauge 'haproxy.app.request.total.frontend'
  end

  def test_measures_requests_denied
    log

    assert_gauge 'haproxy.app.request.denied.frontend'
  end

  def test_measures_request_errors
    log

    assert_gauge 'haproxy.app.request.error.frontend'
  end

  def test_measures_downtime
    log

    assert_gauge 'haproxy.app.downtime.frontend'
  end

  private
  def log
    gauge.log
  end
end
