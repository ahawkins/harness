# Harness

Harness connects measurements coming from `ActiveSupport::Notifications`
to external metric tracking services.

Currently Supported Services:

* Librato

## Installation

Add this line to your application's Gemfile:

    gem 'harness'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install harness

## Usage

In the metrics world there are two types of things: Gauges and Counters.
Gauges are time senstive and represent something at a specific point in
time. Counters keep track of things and should be increasing. Counters
can be reset back to zero. You can combine counters and/or gauges to
correlate data about your application.

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

You can do the same with a counter

```ruby
class MyClass
  def important_method(stuff)
    ActiveSupport::Notifications.instrument "important_method.my_class", :counter => 11 do
      do_important_stuff
    end
  end
end
```

The instuments name will be sent as the name (`important_method.my_class`) 
for that gauge or counter.

Harness will do all the extra work in sending these metrics to whatever
service you're using.

## Rails Integration

Harness will automatically log metrics coming from `ActionPack`,
`ActiveRecord`, `ActiveSupport` and `ActionMailer`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
