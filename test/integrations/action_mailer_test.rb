require_relative '../test_helper'

class ActionMailerIntegration < MiniTest::Unit::TestCase
  def test_logs_mail_received
    instrument "receive"

    assert_timer "action_mailer.receive"
  end

  def test_logs_mail_delivered
    instrument "deliver"

    assert_timer "action_mailer.deliver"
  end

  private
  def instrument(event)
    super "#{event}.action_mailer", { }
  end
end
