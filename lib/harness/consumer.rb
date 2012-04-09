module Harness
  class Consumer
    def consume
      Thread.new do
        while measurement = queue.pop
          case measurement.class.to_s.demodulize.underscore.to_sym
          when :gauge
            adapter.log_gauge measurement
          when :counter
            adapter.log_counter measurement
          end

          mutex.synchronize { @finished = queue.empty? }
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
  end
end
