require 'test_helper'

class ActionMailerIntegration < MiniTest::Unit::TestCase
  def setup
    Harness.adapter = :null
    gauges.clear
  end

  def test_logs_mail_received
    instrument "receive"

    assert_gauge_logged "receive.action_mailer"
  end

  def test_logs_mail_delivered
    instrument "deliver"

    assert_gauge_logged "deliver.action_mailer"
  end

  private
  def instrument(event)
    ActiveSupport::Notifications.instrument "#{event}.action_mailer" do |*args|
      # nada
    end
  end

  def assert_gauge_logged(name)
    refute_empty gauges.select {|g| g.name = name }, "Expected #{gauges.inspect} to contain a #{name} result"
  end

  def gauges
    Harness::NullAdapter.gauges
  end
end
