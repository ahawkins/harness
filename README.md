# Harness

Harness connects measurements coming from `ActiveSupport::Notifications`
to external metric tracking services. Counters are stored locally with
redis before being sent to the service.

Currently Supported Services:

* Librato
* Statsd (thanks to fluxlux)
* Stathat

Current Features:

* Track counters over time (# of registered users)
* Read time specific values (# time to cache something)
* Build meters on top of counters (# requests per second)
* Sidekiq integration
* Resque integration
* Rails integration
* Capture and log all measurements coming out of Rails

**Crash Course**

```ruby
class ComplicatedClass
  def hard_work
    # Automatically track how long each of these calls takes so they can
    # tracked and compared over time.
    ActiveSupport::Notifications.instrument "hard_work", :gauge => true do
      # do hard_work
    end
  end

  def register_user
    # Automatically track the total # of registered users you have.
    # As well, as be able to take measurements of users created in a
    # specific interval
    ActiveSupport::Notifications.instrument "register_user", :counter => true do
      # register_user
    end
  end
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'harness'
```

And then execute:

```shell
bundle
```

Or install it yourself as:

```shell
gem install harness
```

## Usage

In the metrics world there are two types of things: Gauges and Counters.
Gauges are time sensitive and represent something at a specific point in
time. Counters keep track of things and should be increasing. Counters
can be reset back to zero. You can combine counters and/or gauges to
correlate data about your application. Meters monitor counters. They
allow you look at rates of counters (read: counters per second).

Harness makes this process easily. Harness' primary goal it make it dead
simple to start measuring different parts of your application.
`ActiveSupport::Notifications` makes this very easy because it provides
measurements and implements the observer pattern.

## Tracking Things

I guess you read the `ActiveSupport::Notifications`
[documentation](http://api.rubyonrails.org/classes/ActiveSupport/Notifications.html)
before going any further or this will seems like php to you. Harness
hooks into your notifications and looks for `:gauge` or `:counter`
options. If either is present, it will be sent to the external service.
For example, you can track how long it's taking to do a specific thing:

```ruby
class MyClass
  def important_method(stuff)
    ActiveSupport::Notifications.instrument "important_method.my_class", :gauge => true do
      do_important_stuff
    end
  end
end
```

You can do the same with a counter. Counter values are automatically
stored in redis and incremented. This means you can simply pass
`:counter => true` in instrumentations if you'd like to count it. You
may also pass `:counter => 5` if you'd like to provide your own value.
This value is stored in redis so the next time `:counter => true` will
work correctly. You can reset all the counters back to zero by calling:
`Harness.reset_counters!`. 

**NOTE**: You should use the bundled rake task to reset counters with 
a cron job. This will prevent unbounded growth of this metadata. You
can call `rake harness:reset_counters` to do this. You should call
this rake task at whatever your longest measurable interval is. Here's
an example: You log gauges every 12 hours. You should reset the
counters every 12 hours. This issue is discussed [here](https://github.com/twinturbo/harness/issues/15).

```ruby
class MyClass
  def important_method(stuff)
    ActiveSupport::Notifications.instrument "important_method.my_class", :counter => true do
      do_important_stuff
    end
  end
end
```

The instruments name will be sent as the name (`important_method.my_class`)
for that gauge or counter.

Note that `ActiveSupport::Notifications.instrument` doesn't require
a block. This can be useful when you are taking an instant measurement.

```ruby
class MyClass
  def important_method(stuff)
    ActiveSupport::Notifications.instrument "important_method.my_class", :counter => true
  end
end
```

Harness will do all the extra work in sending these metrics to whatever
service you're using.

Once you the counters are you are instrumented, then you can meter them.
Meters allow you take arbitrary readings of counter rates. The results
return a gauge so they can be logged as well.

```ruby
# Define a counter
class MyClass
  def important_method(stuff)
    ActiveSupport::Notifications.instrument "important_method.my_class", :counter => true do
      do_important_stuff
    end
  end
end

# Now you can meter it
meter = Harnes::Meter.new('important_method.my_class')
meter.per_second # returns a gauge
meter.per_second.value # if you just want the number
meter.per(1.hour).value # You can use your own interval
meter.per_minute
meter.per_hour
```

## Customizing

You can pass a hash to `:counter` or `:gauge` to initialize the
measurement your own way.

If you pass a value attribute to a gauge, it will be the value
sent instead of the duration of the block.

```ruby
class MyClass
  def important_method(stuff)
    ActiveSupport::Notifications.instrument "important_method.my_class",
    :gauge => { :id => 'custom-id', :name => "My Measurement",
                :value => my_current_val, :units => 'cogs' } do
      do_important_stuff
    end
  end
end
```

## One Off Gauges and Counters

You can instantiate `Harness::Counter` and `Harness::Gauge` wherever you
want. Events from `ActiveSupport` are just converted to these classes
under the covers anyways. You can use these class if you want to take
periodic measurements or tracking something that happens outside the
application.

```ruby
gauge = Harness::Gauge.new
gauge.id = "foo.bar"
gauge.name = "Foo's Bar"
gauge.time # defaults to Time.now
gauge.value = readings_from_my_server
gauge.units = 'bytes'
gauge.log

counter = Harness::Counter.new
counter.id = "foo.bar"
counter.name = "# of Foo bars"
counter.time # defaults to Time.now
counter.value = read_total_users_in_database
counter.log

### Both classes take an option hash

gauge = Harness::Gauge.new :time => Time.now, :id => 'foo.bar'
counter = Harness::Counter.new :time => Time.now, :id => 'foo.bar'
```

## Configuration

### Librato
```ruby
Harness.config.adapter = :librato

Harness.config.librato.email = 'example@example.com'
Harness.config.librato.token = 'your-api-key'

```

### StatsD

Harness does **not** configure StatsD for you. It uses the StatsD class
under the covers. If you've already configured that in your own way, great.
If not, you can use the configuration proxy as described below. You
must also add `statsd-instrument` to your `Gemfile`. This is a soft
dependency that is not installed for you.

```ruby
Harness.config.adapter = :statsd

# Harness.config.statsd is a proxy for the StatsD class
Harness.config.statsd.host = 'localhost'
Harness.config.statsd.port = '8080'
Harness.config.statsd.default_sample_rate = 0.1
Harness.config.statsd.logger = Rails.logger

# You can assign your own StatsD implementation
# by setting the "backend" attribute
Harness.config.statsd.backend = CustomStatsD
```

### Stathat

```ruby
Harness.config.adapter = :stathat

Harness.config.stathat.ezkey = 'example@example.com'
```

## Rails Integration

Harness will automatically log metrics coming from `ActionPack`,
`ActiveRecord`, and `ActionMailer`. `ActiveSupport` instrumentation is
disabled by default. Also, custom integrations are disabled by default.
You can turn on instrumentation for specific components like so:

```ruby
config.harness.instrument.action_controller = false
config.harness.instrument.active_support = true
config.harness.instrument.sidekiq = true
config.harness.instrument.active_model_serializers = true
```

You can configure Harness from `application.rb`

```ruby
config.harness.adapter = :librato
config.harness.librato.email = 'example@example.com'
config.harness.librato.token = 'your-api-key'
```

Redis will be automatically configured if you `REDISTOGO_URL` or
`REDIS_URL` environment variables at set. They are wrapped in a
namespace so there will be no conflicts. If they are not present, the
default values are used. You can customize this in an initializer:

```ruby
# config/initializers/harness.rb
require 'erb'

file = Rails.root.join 'config', 'resque.yml'
config = YAML.load(ERB.new(File.read(Rails.root.join('config', 'redis.yml'))).result)

Harness.redis = Redis::Namespace.new('harness', :redis => Redis.connect(:url => config[Rails.env]))
```

`rake harness:reset_counters` is also added.

### Rails Environments

Measurements are completely ignored in the test env. They are processed
in development mode, but not sent to the external service. Everything is
logged in production.

### Background Processing

Harness integrates automatically with Resque or Sidekiq. This is because
reporting measurements can take time and add unnecessary overhead to the
response time. If neither of these libraries are present, measurements
**will be posted in realtime.** You can set your own queue by
specifying a class like so:

```ruby
Harness.config.queue = MyCustomQueue
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
