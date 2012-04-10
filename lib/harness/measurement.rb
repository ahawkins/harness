module Harness
  class Measurement
    attr_accessor :name, :source, :time, :value,
      :description, :display, :units

    def initialize(attributes = {})
      attributes.each_pair do |name, value|
        send "#{name}=", value
      end

      self.time ||= Time.now
      self.units ||= :milliseconds
    end

    def log
      Harness.log self
    end
  end
end
