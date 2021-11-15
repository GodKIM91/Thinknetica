require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'validation'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation

  NUMBER_PATTERN = /^[a-zа-я\d]{3}-?[a-zа-я\d]{2}$/i.freeze
  TYPE_PATTERN = /^cargo$|^passenger$/.freeze

  attr_reader :speed, :vagons, :current_station, :type, :number

  validate :number, :format, NUMBER_PATTERN
  validate :type, :presence
  validate :type, :format, TYPE_PATTERN

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number, type)
    @number = number
    @type = type
    @vagons = []
    @speed = 0
    @@trains[number] = self
    validate!
    register_instance
  end

  def attach_vagon(vagon)
    if type == vagon.type
      staying? ? @vagons << vagon : puts('Нужно остановиться!')
    else
      raise "Нельзя прицепить к поезду с типом #{type} вагон с типом #{vagon.type}"
    end
  end

  def detach_vagon
    staying? ? @vagons.delete_at(-1) : puts('Нужно остановиться!')
  end

  # ставим поезд на первую станцию при назначении маршрута
  def route=(route)
    @route = route
    change_current_station(0)
  end

  def move_forward
    change_current_station(next_station_index)
  end

  def move_backward
    change_current_station(previous_station_index)
  end

  def change_current_station(index)
    @current_station.depart_train(self) unless @current_station.eql?(nil)
    @current_station = @route.stations[index]
    @current_station.arrive_train(self)
    @current_station_index = index
  end

  def each_vagon(&block)
    vagons.each(&block)
  end

  def to_s
    "Поезд: #{@number}, тип: #{type}, число вагонов: #{vagons.size}\nСейчас на станции: #{current_station}\nСледует по маршруту: #{@route}\n"
  end

  protected

  # методы ниже protected, поскольку вызываются только в контексте класса Train

  def increase_speed(speed = 1)
    @speed += speed
  end

  # останавливаем поезд, чтоб цеплять/отцеплять вагоны
  def stop
    @speed = 0
  end

  # проверка поезда на нулевую скорость
  def staying?
    speed.zero?
  end

  def next_station
    @route.stations[next_station_index]
  end

  def previous_station
    @route.stations[previous_station_index]
  end

  def next_station_index
    @current_station_index + 1
  end

  def previous_station_index
    @current_station_index - 1
  end

end
