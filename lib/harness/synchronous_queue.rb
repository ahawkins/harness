module Harness
  class SynchronousQueue
    def push(msg)
      method_name = msg.first
      args = msg.last

      statsd.__send__ method_name, *args
    end

    def statsd
      Harness.config.statsd
    end
  end
end
