require 'bundler/setup'
require 'statsd'
require 'harness'
require 'benchmark'
require 'sequel'

Harness.config.statsd = Statsd.new

db = Sequel.sqlite

db.create_table :items do
  primary_key :id
  String :name
  Float :price
end

n = 10_000

Benchmark.bm do |x|
  x.report "w/o instrumentation" do
    n.times do |i|
      db[:items].insert name: "Product #{i}", price: rand
    end
  end

  x.report "w/ instrumentation" do
    Sequel.extension :harness_instrumentation
    n.times do |i|
      db[:items].insert name: "Product #{i}", price: rand
    end
  end
end
