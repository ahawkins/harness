module Harness
  class Measurement
    attr_accessor :id, :name, :source, :time, :value, :units

    def initialize(attributes = {})
      attributes.each_pair do |name, value|
        send "#{name}=", value
      end

      self.time ||= Time.now
    end

    def time=(value)
      if value.is_a? String
        @time = DateTime.parse value
      elsif value.is_a? Fixnum
        @time = Time.at value
      else
        @time = value
      end
    end

    def log
      Harness.log self
    end

    def attributes
      { 
        :id => id,
        :name => name,
        :source => source,
        :time => time,
        :units => units
      }
    end
  end
end
