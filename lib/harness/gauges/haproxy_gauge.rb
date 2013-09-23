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
        pxname = row.field 'pxname'
        server = row.field('svname').downcase

        gauge "haproxy.#{pxname}.queue.current.#{server}", row.field('qcur').to_i
        gauge "haproxy.#{pxname}.queue.max.#{server}", row.field('qmax').to_i

        gauge "haproxy.#{pxname}.session.current.#{server}", row.field('scur').to_i
        gauge "haproxy.#{pxname}.session.max.#{server}", row.field('smax').to_i
        gauge "haproxy.#{pxname}.session.limit.#{server}", row.field('slim').to_i
        gauge "haproxy.#{pxname}.session.total.#{server}", row.field('stot').to_i

        gauge "haproxy.#{pxname}.bytes.in.#{server}", row.field('bin').to_i
        gauge "haproxy.#{pxname}.bytes.out.#{server}", row.field('bout').to_i

        gauge "haproxy.#{pxname}.request.denied.#{server}", row.field('dreq').to_i
        gauge "haproxy.#{pxname}.request.error.#{server}", row.field('ereq').to_i

        gauge "haproxy.#{pxname}.response.1xx.#{server}", row.field('hrsp_1xx').to_i
        gauge "haproxy.#{pxname}.response.2xx.#{server}", row.field('hrsp_2xx').to_i
        gauge "haproxy.#{pxname}.response.3xx.#{server}", row.field('hrsp_3xx').to_i
        gauge "haproxy.#{pxname}.response.4xx.#{server}", row.field('hrsp_4xx').to_i
        gauge "haproxy.#{pxname}.response.5xx.#{server}", row.field('hrsp_5xx').to_i

        gauge "haproxy.#{pxname}.request.rate.#{server}", row.field('req_rate').to_i
        gauge "haproxy.#{pxname}.request.max_rate.#{server}", row.field('req_rate_max').to_i

        gauge "haproxy.#{pxname}.request.total.#{server}", row.field('req_tot').to_i

        gauge "haproxy.#{pxname}.downtime.#{server}", row.field('downtime').to_i
      end
    end
  end
end
