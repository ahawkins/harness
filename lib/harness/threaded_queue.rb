require 'thread'

module Harness
  class ThreadedQueue
    attr_reader :consumer, :queue

    def initialize
      @queue = Queue.new
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

    def collector
      Harness.config.collector
    end
  end
end
