module Harness
  class SyncronousQueue
    def self.push(measurement)
      Harness::Job.new.perform(measurement)
    end
  end
end
