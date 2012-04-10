module Harness
  class SyncronousQueue
    def self.push(measurement)
      begin
        Harness::Job.new.log(measurement)
      rescue LoggingError => ex
        logger.debug "[Harness] Logging measurement failed! Server Said: #{ex}"
        logger.debug ex.backtrace.join("\n")
        logger.warn "[Harness] Could not post measurement! Enable debug logging to see full errors"
      end
    end
  end
end
