require 'test_helper'
require 'harness/integration/active_model_serializers'

class ActiveModelSerializerIntegration < IntegrationTest
  def test_serializable_hash_is_logged
    instrument "serializable_hash"

    assert_gauge_logged "serializable_hash.serializer"
  end

  def test_serializing_associations_is_logged
    instrument "associations"

    assert_gauge_logged "associations.serializer"
  end

  def instrument(event)
    ActiveSupport::Notifications.instrument "#{event}.serializer" do |*args|
      # nada
    end
  end
end
