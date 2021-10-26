class Route
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
  end

  #ставим промежуточную точку сначала между первой и последней станцией
  #затем они будут вставляться между предпоследней и последней по порядку от первой вставленной
  def add_station(station)
    @stations.insert(-2, station)
  end

  #на всякий случай добавил защиту от удаления first_station и last_station
  def delete_station(station)
    unless %w(@stations.first @stations.last).include?(station)
      @stations.delete(station)
    else
      puts "Нельзя удалить начальную и конечную станции маршрута"
    end
  end

  def to_s
    "Маршрут: #{@stations.first.name} - #{@stations.last.name}"
  end
end