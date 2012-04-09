require 'json'
require 'uri'
require 'net/http'

module Harness
  class LibratoAdapter
    class WebServiceError < RuntimeError ; end

    class Config 
      attr_accessor :email, :token
    end

    def self.config
      @config ||= Config.new
    end

    def self.log_gauge(gauge)
      raise WebServiceError if gauge.name.length >= 63

      post({:gauges => [{
        :name => sanitize(gauge.name),
        :value => gauge.value,
        :time => gauge.time.to_i,
        :source => gauge.source
      }]})
    end

    def self.log_counter(counter)
      raise WebServiceError if counter.name.length >= 63

      post({:counters => [{
        :name => sanitize(counter.name),
        :value => counter.value,
        :time => counter.time.to_i,
        :source => counter.source
      }]})
    end

    private
    def self.post(params)
      unless config.email && config.token
        raise "Adapter not configured. Ensure email and token are set."
      end

      uri = URI.parse('https://metrics-api.librato.com/v1/metrics')

      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Post.new uri.request_uri

        request.basic_auth config.email, config.token
        request['Content-Type'] = 'application/json'
        request.body = params.to_json

        response = http.request request

        raise WebServiceError, response.body unless response.code.to_i == 200
      end

      true
    end

    def self.sanitize(name)
      name.gsub(/\./, '-')
    end
  end
end
