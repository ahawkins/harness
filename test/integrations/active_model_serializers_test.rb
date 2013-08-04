require_relative '../test_helper'
require 'harness/integration/active_model_serializers'

class ActiveModelSerializerIntegration < MiniTest::Unit::TestCase
  def test_serializable_hash_is_logged
    instrument "serializable_hash"

    assert_timer "serializer.serializable_hash"
  end

  def test_serializing_associations_is_logged
    instrument "associations"

    assert_timer "serializer.associations"
  end

  def instrument(event)
    super "#{event}.serializer", { }
  end
end
