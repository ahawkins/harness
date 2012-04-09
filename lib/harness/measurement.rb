module Harness
  class Measurement
    attr_accessor :name, :source, :time, :value

    def initialize(attributes = {})
      attributes.each_pair do |name, value|
        send "#{name}=", value
      end
    end

    def log
      Harness.log self
    end
  end
end
