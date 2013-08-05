module Sidekiq
  module Middleware
    module Server
      class HarnessInstrumentation
        include Harness::Instrumentation

        def call(worker_class, item, queue)
          instrument "sidekiq.#{worker_class.underscore}" do
            yield
          end

          increment "sidekiq.job"
        end
      end
    end
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::HarnessInstrumentation
  end
end
