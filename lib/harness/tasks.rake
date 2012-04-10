namespace :harness do
  desc "Reset all counters back to zero"
  task :reset_counters => :environment do
    Harness.reset_counters!
  end
end
