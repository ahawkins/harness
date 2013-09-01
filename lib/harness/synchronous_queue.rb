module Harness
  class SynchronousQueue
    def push(msg)
      method_name = msg.first
      args = msg.last

      collector.__send__ method_name, *args
    end

    def collector
      Harness.collector
    end
  end
end
