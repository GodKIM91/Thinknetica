require_relative 'instance_counter'
require_relative 'validation'

class Station
  include InstanceCounter
  include Validation

  NAME_PATTERN = /^[a-z]{3,10}$/i #название станции - любое слово от 3 до 10 букв без чувствительности к регистру

  attr_reader :trains, :name

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@stations << self
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

  def each_train
    trains.each { |train| yield(train) }
  end

  def to_s
    "Остановка: #{name}"
  end

  protected
  def validate!
    raise 'Wrong station name, try any chars with length 3..10' if @name !~ NAME_PATTERN
  end

end