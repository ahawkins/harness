module Harness
  class RackInstrumenter
    include Instrumentation

    def initialize(app, namespace = nil)
      @app, @namespace = app, namespace
    end

    def call(env)
      status, headers, body = instrument stat_name('rack.request') do
        @app.call env
      end

      increment "#{stat_name("rack.request")}.#{status}"

      [status, headers, body]
    end

    def stat_name(name)
      if @namespace
        "#{name}.#{@namespace}"
      else
        name
      end
    end
  end
end
