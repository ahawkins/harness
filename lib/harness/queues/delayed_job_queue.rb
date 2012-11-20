module Harness
  class DelayedJobQueue
    def push(measurement)
      Harness::Job.new.delay(:queue => 'harness').log(measurement)
    end
  end
end
