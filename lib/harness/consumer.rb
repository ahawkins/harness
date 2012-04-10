module Harness
  class Consumer
    def consume
      Thread.new do
        while measurement = queue.pop
          begin
            logger.debug "Processing Measurement: #{measurement.inspect}"

            case measurement.class.to_s.demodulize.underscore.to_sym
            when :gauge
              adapter.log_gauge measurement
            when :counter
              adapter.log_counter measurement
            end
          rescue LoggingError => ex
            logger.debug "Logging measurement failed! Server Said: #{ex}"
            logger.debug ex.backtrace.join("\n")
            logger.warn "Could not post measurement! Enable debug logging to see full errors"
          ensure
            mutex.synchronize { @finished = queue.empty? }
          end
        end
      end
    end

    def finished?
      @finished
    end

    private
    def queue
      Harness.queue
    end

    def adapter
      Harness.config.adapter
    end

    def mutex
      Harness.mutex
    end

    def logger
      Harness.logger
    end
  end
end
