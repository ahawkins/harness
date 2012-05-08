require 'test_helper'

class ActiveSupportTestCase < IntegrationTest
  def test_a_gauge_is_logged
    ActiveSupport::Notifications.instrument "gauge_test.harness", :gauge => true do |args|
      # do nothing
    end

    assert_gauge_logged "gauge_test.harness"
  end

  def test_a_counter_is_logged
    ActiveSupport::Notifications.instrument "counter_test.harness", :counter => { :value => 5 } do |args|
      # do nothing
    end

    assert_counter_logged "counter_test.harness"
  end

  def test_can_log_both
    ActiveSupport::Notifications.instrument "test.harness", :gauge => { :id => "test-gauge" }, :counter => {:id => 'test-counter', :value => 5 } do |args|
      # do nothing
    end

    assert_counter_logged "test-counter"
    assert_gauge_logged "test-gauge"
  end

  def test_does_not_log_counter_on_exception
    begin
      ActiveSupport::Notifications.instrument "counter_test.harness", :counter => true do |args|
        raise
      end
    rescue
    end

    assert_counter_not_logged "counter_test.harness"
  end

  def test_does_not_log_gauge_on_exception
    begin
      ActiveSupport::Notifications.instrument "gauge_test.harness", :gauge => true do |args|
        raise
      end
    rescue
    end

    assert_gauge_not_logged "gauge_test.harness"
  end
end
