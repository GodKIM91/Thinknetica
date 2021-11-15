require_relative 'instance_counter'
require_relative 'validation'
require_relative 'accessors'

class Station
  include InstanceCounter
  include Validation
  include Acсessors

  NAME_PATTERN = /^[a-z]{3,10}$/i.freeze

  attr_accessor_with_history :trains, :name

  validate :name, :format, NAME_PATTERN

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    validate!
    register_instance
  end

  def arrive_train(train)
    @trains << train
  end

  def depart_train(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    trains.select { |train| train.type == type }
  end

  def each_train(&block)
    trains.each(&block)
  end

  def to_s
    "Остановка: #{name}"
  end

end
