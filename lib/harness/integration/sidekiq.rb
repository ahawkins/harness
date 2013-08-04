module Sidekiq
  module Middleware
    module Server
      class HarnessInstrumentation
        def call(worker_class, item, queue)

          ActiveSupport::Notifications.instrument "sidekiq.#{worker_class.underscore}", counter: true, timer: true do
            yield
          end

          ActiveSupport::Notifications.instrument "sidekiq.job", counter: true
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
