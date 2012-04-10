module Harness
  class Measurement
    attr_accessor :id, :name, :source, :time, :value, :units

    def initialize(attributes = {})
      attributes.each_pair do |name, value|
        send "#{name}=", value
      end

      self.time ||= Time.now
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
        :units => units,
      }
    end

    def to_json
      attributes.to_json
    end
  end
end
