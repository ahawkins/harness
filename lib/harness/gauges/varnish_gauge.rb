require 'uri'
require 'net/http'
require 'multi_json'

module Harness
  class VarnishGauge
    include Instrumentation

    def initialize(url, user, pass)
      @url, @user, @pass = url, user, pass
    end

    def log
      uri = URI.parse "http://#{@url}/stats"

      http = Net::HTTP.new uri.host, uri.port
      request = Net::HTTP::Get.new uri.request_uri
      request.basic_auth @user, @pass
      response = http.request request
      body = MultiJson.load response.body

      hits = body.fetch('cache_hit').fetch('value')
      misses = body.fetch('cache_miss').fetch('value')
      hit_rate = (hits.to_f / (hits + misses).to_f) * 100

      gauge 'varnish.hits', hits
      gauge 'varnish.misses', misses
      gauge 'varnish.hit_rate', hit_rate

      gauge 'varnish.cached', body.fetch('n_object').fetch('value')
    end
  end
end
