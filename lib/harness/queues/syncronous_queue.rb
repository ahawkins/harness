module Harness
  class SyncronousQueue
    def self.push(measurement)
      Harness::Job.new.log(measurement)
    end
  end
end
