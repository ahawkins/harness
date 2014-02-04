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

These metrics should be enough to give you a high level overview on
how all the different layers in your stack are performing. **Harness
is not for drilling down into a specific request or peice of code.**
You should use the ruby-prof for that. In short, Harness is not a
replacement for new-relic. They serve different purposes. However, you
could deduce all the information newrelic provides from
instrumentation data.

## Supported Libraries & Projects

Harness is an interface. All integrations use the interface.
Instrumentation for popular libraries are provided as gems. This
allows anyone to release instrumentations. Individual gems can be
maintained and released separate of this gem. Here is the definite
list.

* [harness-actioncontroller](http://github.com/ahawkins/harness-actioncontroller)
* [harness-actionmailer](http://github.com/ahawkins/harness-actionmailer)
* [harness-actionview](http://github.com/ahawkins/harness-actionview)
* [harness-activerecord](http://github.com/ahawkins/harness/activerecord)
* [harness-active\_model\_serialzier](http://github.com/ahawkins/harness-active_model_serializers)
* [harness-activesupport](http://github.com/ahawkins/harness-activesupport)
* [harness-haproxy](http://github.com/ahawkins/harness-haproxy)
* [harness-memcached](http://github.com/ahawkins/harness-memcached) - [dalli](http://github.com/merpahm/dalli) through harness-activesupport
* [harness-moped](http://github.com/ahawkins/harness-moped) - (mongoid)
* [harness-rack](http://github.com/ahawkins/harness-rack)
* [harness-redis](http://github.com/ahawkins/harness-redis)
* [harness-sequel](http://github.com/ahawkins/harness-sequel)
* [harness-sidekiq](http://github.com/ahawkins/harness-sidekiq)
* [harness-varnish](http://github.com/ahawkins/harness-varnish)

## Instrumenting

`Harness` provides the same interface as `statsd`. You can interact
with `Harness` directly. This is not advised. You should `include` or
`extend` `Harness::Instrumentation` in your class. Here are some
examples.

```ruby
class UseCase
  include Harness::Instrumentation

  def run!
    increment 'foo'
    increment 'foo', 5

    decrement 'foo'
    decrement 'foo', 5

    count 'foo', 1000

    time 'foo' do
      # do hard work
    end
  end
end
```

That's all there is to it!

## Configuring

Harness has two configuration options: the queue and collector.
`Harness::AsyncQueue` is the default queue. This means all metrics are
logged in a separate thread to never block the main thread. This makes
harness more performant in high traffic scenarios.
`Harness::NullCollector`. There is also a `Harness::SyncQueue`
useful for testing (but really used in practice).

```
Harness.config.collector = Statsd.new 'something.com'
Harness.config.queue = Harness::AsyncQueue
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

