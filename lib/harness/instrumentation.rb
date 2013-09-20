require 'active_support/core_ext/module'
require 'active_support/concern'

module Harness
  module Instrumentation
    extend ActiveSupport::Concern

    included do
      delegate :timing, :time, :gauge, :increment, :decrement, :instrument, to: :harness
    end

    private
    def harness
      Harness
    end
  end
end
