module Sidekiq
  module Middleware
    module Server
      class HarnessInstrumentation
        include Harness::Instrumentation

        def call(worker, item, queue)
          time "sidekiq.#{worker.class.name.underscore.gsub('/', '.')}" do
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
