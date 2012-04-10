module Harness
  class Consumer
    def consume
      Thread.new do
        while measurement = queue.pop
          begin
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
