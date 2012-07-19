require 'uri'
require 'net/http'

module Harness
  class StathatAdapter
    class Config
      attr_accessor :ezkey
    end

    def self.config
      @config ||= Config.new
    end

    def log_gauge(gauge)
      raise Harness::LoggingError if gauge.id.length > 255

      post({
        :stat => sanitize(gauge.id),
        :value => gauge.value,
      })
    end

    def log_counter(counter)
      raise Harness::LoggingError if counter.id.length > 255

      post({
        :stat => sanitize(counter.id),
        :count => counter.value,
      })
    end

    private

    def post(params)
      unless config.ezkey
        raise "Adapter not configured. Ensure ezkey is set."
      end

      uri = URI.parse('https://api.stathat.com/ez')

      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Post.new uri.request_uri

        request.set_form_data params.merge(:ezkey => config.ezkey)

        response = http.request request

        unless response.code.to_i == 200
          text = %Q{
          Server Said: #{response.body}
          Sent: #{params.inspect}
          }

          raise Harness::LoggingError, text
        end
      end

      true
    end

    def config
      self.class.config
    end

    def sanitize(name)
      if Harness.config.namespace
        key = "#{name}.#{Harness.config.namespace}"
      else
        key = name
      end

      key.gsub('/', '.')
    end
  end
end
