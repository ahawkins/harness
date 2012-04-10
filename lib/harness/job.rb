module Harness
  class Job
    def log(measurement)
      logger.debug "[Harness] Processing Measurement: #{measurement.inspect}"

      case measurement.class.to_s.demodulize.underscore.to_sym
      when :gauge
        adapter.log_gauge measurement
      when :counter
        adapter.log_counter measurement
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
