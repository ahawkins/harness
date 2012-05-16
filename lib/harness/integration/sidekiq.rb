module Sidekiq
  module Middleware
    module Server
      class HarnessInstrumentation
        def call(worker_class, item, queue)
          if instrument? worker_class
            options = {}
            options[:gauge] = "#{worker_class.class.to_s.underscore}.sidekiq"
            options[:counter] = "#{worker_class.class.to_s.pluralize.underscore}.sidekiq"

            ActiveSupport::Notifications.instrument "#{worker_class.class.to_s.underscore}.sidekiq", options do
              yield
            end

            ActiveSupport::Notifications.instrument "job.sidekiq", :counter => true
          else
            yield
          end
        end

        private
        def instrument?(worker_class)
          worker_class !~ /^Harness/
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
