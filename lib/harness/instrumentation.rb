require 'active_support/core_ext/module'
require 'active_support/concern'

module Harness
  module Instrumentation
    extend ActiveSupport::Concern

    included do
      delegate :timing, :time, :gauge, :increment, to: :harness
    end

    def instrument(name, sample_rate = 1, &block)
      result = time name, sample_rate, &block
      increment name, 1, sample_rate
      result
    end

    private
    def harness
      Harness
    end
  end
end
