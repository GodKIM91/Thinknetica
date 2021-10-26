class Train
  attr_reader :speed, :vagons_count, :current_station, :type, :number

  def initialize(number, type, vagons_count)
    @number = number.to_s
    @type = type
    @vagons_count = vagons_count
    @speed = 0
  end

  def increase_speed(speed = 1)
    @speed += speed
  end
  
  #останавливаем поезд, чтоб цеплять/отцеплять вагоны
  def stop
    @speed = 0
  end

  #проверка поезда на нулевую скорость
  def is_staying
    speed == 0
  end

  def attach_vagon
    is_staying ? @vagons_count += 1 : puts('Нужно остановиться!')
  end

  def detach_vagon
    is_staying ? @vagons_count -= 1 : puts('Нужно остановиться!')
  end

  #ставим поезд на первую станцию при назначении маршрута
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

  def next_station
    @route.stations[next_station_index]
  end

  def previous_station
    @route.stations[previous_station_index]
  end

  def change_current_station(index)
    @current_station.depart_train(self) unless @current_station.eql?(nil)
    @current_station = @route.stations[index]
    @current_station.arrive_train(self)
    @current_station_index = index
  end

  def next_station_index
    @current_station_index + 1
  end

  def previous_station_index
    @current_station_index - 1
  end

  def to_s
    "Поезд: #{@number}, тип: #{type}\nСейчас на станции: #{current_station}\nСледует по маршруту: #{@route}"
  end

end