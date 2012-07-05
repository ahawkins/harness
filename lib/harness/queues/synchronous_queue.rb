module Harness
  class SynchronousQueue
    def push(measurement)
      begin
        Harness::Job.new.log(measurement)
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
  end
  # Preserve previous spelling for backward compatibility
  SyncronousQueue = SynchronousQueue
end
