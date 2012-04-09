require 'test_helper'

class ActionMailerIntegration < IntegrationTest
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
end
