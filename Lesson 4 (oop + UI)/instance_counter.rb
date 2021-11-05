module InstanceCounter
  #немного переделал модуль, эта реализация кажется более читаемой
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def instances
      @instances_qty || 0
    end

    def instances_increment
      @instances_qty ||= 0
      @instances_qty += 1
    end
  end

  module InstanceMethods

    protected

    def register_instance
      self.class.instances_increment
    end
  end
end