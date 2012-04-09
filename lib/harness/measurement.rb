module Harness
  class Measurement
    attr_accessor :name, :source, :time, :value

    def initialize(attributes = {})
      attributes.each_pair do |name, value|
        send "#{name}=", value
      end
    end

    def log
      Harness.adapter.send "log_#{self.class.to_s.demodulize.underscore}", self
    end
  end
end
