module Harness
  class RackInstrumenter
    include Instrumentation

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = instrument 'rack.request' do
        @app.call env
      end

      increment "rack.request.#{status}"

      [status, headers, body]
    end
  end
end
