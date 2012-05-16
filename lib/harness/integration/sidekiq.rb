module Sidekiq
  module Middleware
    module Server
      class HarnessInstrumentation
        def call(worker_class, item, queue)
          if instrument? worker_class
            logger.debug "Instrumenting: #{worker_class.inspect}"

            options = {}
            options[:gauge] = "#{worker_class.class.to_s.underscore}.sidekiq"
            options[:counter] = "#{worker_class.class.to_s.pluralize.underscore}.sidekiq"

            ActiveSupport::Notifications.instrument "#{worker_class.class.to_s.underscore}.sidekiq", options do
              yield
            end

            ActiveSupport::Notifications.instrument "job.sidekiq", :counter => true
          else
            logger.debug "Skipped Instrumenting: #{worker_class.inspect}"
            yield
          end
        end

        private
        def instrument?(worker_class)
          worker_class.to_s !~ /^harness/i
        end

        def logger
          Sidekiq.logger
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
