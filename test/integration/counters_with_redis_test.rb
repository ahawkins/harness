require 'test_helper'

class CountersWithRedis < IntegrationTest
  def test_stores_name_in_redis
    instrument "event-counter", :counter => true

    assert_includes redis.smembers('counters'), 'event-counter'
    assert_equal 1, redis.get('event-counter').to_i

    assert_counter_logged "event-counter"
  end

  def test_increments_counter_each_instrument
    instrument "event-counter", :counter => true
    assert_counter_logged "event-counter"
    counters.clear

    assert_empty counters
    instrument "event-counter", :counter => true
    assert_counter_logged "event-counter"

    assert_equal 2, counters.first.value
  end

  def test_sets_given_value_in_redis_with_shortform
    instrument "event-counter", :counter => 10

    assert_equal 10, redis.get("event-counter").to_i

    counters.clear

    instrument "event-counter", :counter => true
    assert_counter_logged 'event-counter'

    assert_equal 11, counters.first.value
  end

  def test_sets_given_value_in_redis_with_longform
    instrument "event-counter", :counter => { :value => 10 }

    assert_equal 10, redis.get("event-counter").to_i

    counters.clear

    instrument "event-counter", :counter => true
    assert_counter_logged 'event-counter'

    assert_equal 11, counters.first.value
  end

  def test_resets_counters
    instrument "event-counter", :counter => true
    instrument "event-counter2", :counter => true

    assert_equal 1, redis.get("event-counter").to_i
    assert_equal 1, redis.get("event-counter2").to_i

    Harness.reset_counters!

    assert_equal -1, redis.get("event-counter").to_i
    assert_equal -1, redis.get("event-counter2").to_i

    counters.clear
    instrument "event-counter", :counter => true
    assert_counter_logged 'event-counter'

    assert_equal 0, counters.first.value
  end
end
