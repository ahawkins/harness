require 'thread'

module Harness
  class AsyncQueue
    attr_reader :queue, :consumer

    def initialize(queue = Queue.new, collector = Harness.collector)
      @queue = queue

      @consumer = Thread.new do
        loop do
          msg = queue.pop

          method_name = msg.first
          args = msg.last

          collector.__send__ method_name, *args
        end
      end
    end

    def push(msg)
      queue.push msg
    end

    def stop
      consumer.kill
    end

    def up?
      consumer.alive?
    end
  end
end
