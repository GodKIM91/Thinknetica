module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(name, type, *args)
      @validate ||= []
      @validate << { name: name, type: type, args: args}
    end
  end

  module InstanceMethods
    def validate!
      self.class.instance_variable_get(:@validate).each do |hash|
        name = hash[:name]
        value = instance_variable_get("@#{name}".to_sym)
        type = hash[:type]
        args = hash[:args].first
        send("validate_#{type}".to_sym, name, value, args)
      end
    end

    def validate_presence(name, value, arg)
      raise "#{name} is not set" if value.nil? || value.to_s.empty?
    end

    def validate_format(name, value, regexp)
      raise "#{name} should be match #{regexp}!" if value !~ regexp
    end

    def validate_type(name, value, type)
      raise "Type #{name} should be #{type}" unless value.is_a?(type)
    end
  end
end
