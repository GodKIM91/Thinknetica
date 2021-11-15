require_relative 'instance_counter'
require_relative 'validation'
require_relative 'station'

class Route
  include InstanceCounter
  include Validation
  attr_reader :stations

  validate :first_station, :type, Station
  validate :last_station, :type, Station

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @stations = [@first_station, @last_station]
    register_instance
  end

  # ставим промежуточную точку сначала между первой и последней станцией
  # затем они будут вставляться между предпоследней и последней по порядку от первой вставленной
  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station)
  end

  def to_s
    "#{@stations.first.name} - #{@stations.last.name}"
  end
end
