require 'json'
require 'uri'
require 'net/http'

module Harness
  class LibratoAdapter
    class Config 
      attr_accessor :email, :token
    end

    def self.config
      @config ||= Config.new
    end

    def self.log_gauge(gauge)
      raise Harness::LoggingError if gauge.id.length > 63

      post({:gauges => [{
        :name => sanitize(gauge.id),
        :display_name => gauge.name,
        :value => gauge.value,
        :measure_time => gauge.time.to_i,
        :source => gauge.source,
        :attributes => { :display_units_short => gauge.units }
      }]})
    end

    def self.log_counter(counter)
      raise Harness::LoggingError if counter.id.length > 63

      post({:counters => [{
        :name => sanitize(counter.id),
        :display_name => counter.name,
        :value => counter.value,
        :measure_time => counter.time.to_i,
        :source => counter.source,
        :attributes => { :display_units_short => counter.units }
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

        raise Harness::LoggingError, response.body unless response.code.to_i == 200
      end

      true
    end

    def self.sanitize(name)
      base = name.gsub(/^!/, 'bang.')

      if Harness.config.namespace
        "#{name}.#{Harness.config.namespace}"
      else
        base
      end
    end
  end
end
