require 'test_helper'
require 'harness/queues/delayed_job_queue'
require 'fileutils'

class DelayedJobTest < IntegrationTest
  def setup
    super
    
    tmp = File.expand_path('../../../tmp', __FILE__)
    db  = File.join(tmp, 'db.sqlite3')

    FileUtils.mkdir_p tmp
    FileUtils.rm_f db

    ActiveRecord::Base.establish_connection(
      :adapter => "sqlite3",
      :database  => db
    )

    Class.new(ActiveRecord::Migration) do
      def self.up
        suppress_messages do
          create_table :delayed_jobs, :force => true do |table|
            table.integer  :priority, :default => 0      # Allows some jobs to jump to the front of the queue
            table.integer  :attempts, :default => 0      # Provides for retries, but still fail eventually.
            table.text     :handler                      # YAML-encoded string of the object that will do work
            table.text     :last_error                   # reason for last failure (See Note below)
            table.datetime :run_at                       # When to run. Could be Time.zone.now for immediately, or sometime in the future.
            table.datetime :locked_at                    # Set when a client is working on this object
            table.datetime :failed_at                    # Set when all retries have failed (actually, by default, the record is deleted instead)
            table.string   :locked_by                    # Who is working on this object (if locked)
            table.string   :queue                        # The name of the queue this job is in
            table.timestamps
          end

          add_index :delayed_jobs, [:priority, :run_at], :name => 'delayed_jobs_priority'
        end
      end
    end.up

    Delayed::Worker.delay_jobs = false

    Harness.config.queue = :delayed_job
  end

  def test_a_gauge_is_logged
    instrument "test-gauge", :gauge => true

    assert_gauge_logged "test-gauge"
  end

  def test_a_counter_is_logged
    instrument "test-counter", :counter => true

    assert_counter_logged "test-counter"

    assert_equal 1, counters.first.value
  end
end
