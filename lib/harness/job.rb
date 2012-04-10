module Harness
  class Job
    def perform(measurement)
      begin
        logger.debug "[Harness] Processing Measurement: #{measurement.inspect}"

        case measurement.class.to_s.demodulize.underscore.to_sym
        when :gauge
          adapter.log_gauge measurement
        when :counter
          adapter.log_counter measurement
        end
      rescue LoggingError => ex
        logger.debug "[Harness] Logging measurement failed! Server Said: #{ex}"
        logger.debug ex.backtrace.join("\n")
        logger.warn "[Harness] Could not post measurement! Enable debug logging to see full errors"
      end
    end

    private
    def logger
      Harness.logger
    end

    def adapter
      Harness.config.adapter
    end
  end
end
