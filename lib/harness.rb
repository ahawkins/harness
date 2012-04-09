require "harness/version"

require 'active_support/notifications'
require 'active_support/core_ext/string'

module Harness
  def self.adapter=(val)
    if val.is_a? Symbol
      @adapter = "Harness::#{val.to_s.classify}Adapter".constantize
    else
      @adapter = val
    end
  end

  def self.adapter
    @adapter
  end
end

require 'harness/measurement'
require 'harness/counter'
require 'harness/gauge'

require 'harness/adapters/librato_adapter'
require 'harness/adapters/null_adapter'
