require 'uri'
require 'net/http'
require 'csv'

module Harness
  class HAProxyGauge
    include Instrumentation

    def initialize(url, user, pass)
      @url, @user, @pass = url, user, pass
    end

    def log
      uri = URI.parse "http://#{@url}/haproxy?stats;csv"

      http = Net::HTTP.new uri.host, uri.port
      request = Net::HTTP::Get.new uri.request_uri
      request.basic_auth @user, @pass
      response = http.request request

      CSV.parse(response.body, headers: true) do |row|
        pxname = row.fetch 'pxname'
        server = row.fetch('svname').downcase

        gauge "haproxy.#{pxname}.queue.current.#{server}", row.fetch('qcur').to_i
        gauge "haproxy.#{pxname}.queue.max.#{server}", row.fetch('qmax').to_i

        gauge "haproxy.#{pxname}.session.current.#{server}", row.fetch('scur').to_i
        gauge "haproxy.#{pxname}.session.max.#{server}", row.fetch('smax').to_i
        gauge "haproxy.#{pxname}.session.limit.#{server}", row.fetch('slim').to_i
        gauge "haproxy.#{pxname}.session.total.#{server}", row.fetch('stot').to_i

        gauge "haproxy.#{pxname}.bytes.in.#{server}", row.fetch('bin').to_i
        gauge "haproxy.#{pxname}.bytes.out.#{server}", row.fetch('bout').to_i

        gauge "haproxy.#{pxname}.request.denied.#{server}", row.fetch('dreq').to_i
        gauge "haproxy.#{pxname}.request.error.#{server}", row.fetch('ereq').to_i

        gauge "haproxy.#{pxname}.response.1xx.#{server}", row.fetch('hrsp_1xx').to_i
        gauge "haproxy.#{pxname}.response.2xx.#{server}", row.fetch('hrsp_2xx').to_i
        gauge "haproxy.#{pxname}.response.3xx.#{server}", row.fetch('hrsp_3xx').to_i
        gauge "haproxy.#{pxname}.response.4xx.#{server}", row.fetch('hrsp_4xx').to_i
        gauge "haproxy.#{pxname}.response.5xx.#{server}", row.fetch('hrsp_5xx').to_i

        gauge "haproxy.#{pxname}.request.rate.#{server}", row.fetch('req_rate').to_i
        gauge "haproxy.#{pxname}.request.max_rate.#{server}", row.fetch('req_rate_max').to_i

        gauge "haproxy.#{pxname}.request.total.#{server}", row.fetch('req_tot').to_i

        gauge "haproxy.#{pxname}.downtime.#{server}", row.fetch('downtime').to_i
      end
    end
  end
end
