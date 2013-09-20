# Harness
[![Build Status](https://secure.travis-ci.org/ahawkins/harness.png?branch=master)][travis]
[![Gem Version](https://badge.fury.io/rb/harness.png)][gem]
[![Code Climate](https://codeclimate.com/github/ahawkins/harness.png)][codeclimate]
[![Dependency Status](https://gemnasium.com/ahawkins/harness.png?travis)][gemnasium]

[gem]: https://rubygems.org/gems/harness
[travis]: http://travis-ci.org/ahawkins/harness
[gemnasium]: https://gemnasium.com/ahawkins/harness
[codeclimate]: https://codeclimate.com/github/ahawkins/harness
[coveralls]: https://coveralls.io/r/ahawkins/harness

Harness provides you with high level application metrics. It collects
metrics from various sources and forwards them to the collector. You
can use any collector that implements the `Statsd` interface. Harness
also collects metrics from `ActiveSupport::Notifications` and forwards
them to the collector.

Harness only assumes one thing: the collector can do proper metric
aggregation and statistics. Example: using statsd will calculate the
90th percentile and averages.

Harness is designed for very high traffic applications. Instrumenting
code should cost as close to 0 as possible. All metrics are processed
in a separate thread. The main thread will never do any more work than
needed. Using a thread allows you to instrument 10,000's metrics per
second without worrying.

Harness's has two main goals:

1. Make instrumentation fast and cheap
2. Provide high level system metrics (think like a car dashboard for
   your app).

Solving #1 is easy: include `Harness::Instrumented` in your class. #2
is slightly more complicated, but Harness automatically collects all
the metrics for you.

## Application Independent Metrics

Most ruby applications are using a similar stack: rack, a cache, a key
value store, job processor, and persistent data store. Visiblity is
the most important thing when it comes to application performance. You
can only improve something when you can measure it. Harness takes care
of the measuring. Harness integrates with common components in the
ruby eosystem and gives you the data you need. You should put this
data on your dashboard and pay attention to it.

Harness provides these metrics for you right out of the box:

* Rack
  * response time
  * requests / second
  * 2xx responses / second
  * 4xx responses / second
  * 5xx responses / second
* Memcached
  * total memory
  * key space size
  * hit rate
* Redis
  * total memory
  * timings off every command (get, set, sadd, etc)
* Sidekiq
  * jobs / second
  * jobs procsssed
  * queue depth
  * failed count
  * retry queue depth
  * schedule queue depth
* Sequel
  * queries / second
  * writes / second
  * reads / second
  * read speed
  * write speed
* ActiveRecord
  * queries / second
  * writes / second
  * reads / second
  * read speed
  * write speed
* Mongoid (Moped)
  * queries / second
  * writes / second
  * reads / second
  * read speed
  * write speed
* ActiveSupport (all timings & per second)
  * reads
  * generates
  * fetches
  * writes
  * deletes
  * hit rate
* ActiveModel::Serializers
  * object serialization time
  * association serialization time
* ActionView
  * template render time
  * partial render time
* ActionMailer
  * delivery time
  * receive time
* ActionController
  * time to write fragment
  * time to read fragment
  * time to expire fragment
  * action time
  * requests / second

These metrics should be enough to give you a high level overview on
how all the different layers in your stack are performing. **Harness
is not for drilling down into a specific request or peice of code.**
You should use the ruby-prof for that. In short, Harness is not a
replacement for new-relic. They serve different purposes. However, you
could deduce all the information newrelic provides from
instrumentation data. This list covers all the shared metrics we have
in common. You get these for free.

## Instrumenting your Code
