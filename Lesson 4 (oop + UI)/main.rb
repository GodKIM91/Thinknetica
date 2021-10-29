require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'vagon'
require_relative 'cargo_vagon'
require_relative 'passenger_vagon'

puts 'Добрый вечер, Вы диспетчер! Выберете действие'

ACTIONS = <<actions
1 - Создать станцию
2 - Создать поезд
3 - Создать маршрут и управлять станциями в нем (добавлять, удалять)
4 - Назначить маршрут поезду
5 - Добавить вагоны к поезду
6 - Отцепить вагоны от поезда
7 - Переместить поезд по маршруту вперед и назад
8 - Просмостреть список станций и список поездов на станции
9 - Выход
actions

TRAIN_TYPES = <<types
1 - Грузовой
2 - Пассажирский
types

MOVE_TRAIN = <<move
1 - Вперед
2 - Назад
move

VAGON_TYPES = <<types
1 - Грузовой
2 - Пассажирский
types

ROUTE_MENU = <<route_menu
1 - Создать маршрут
2 - Добавить промежуточную точку
3 - Удалить промеждуточную точку
route_menu

class Main
  attr_accessor :trains, :stations, :routes, :vagons

  def initialize
    @trains = []
    @stations = []
    @routes = []
    @vagons = []
  end

  def selected_option
    gets.chomp.to_i
  end

  def user_input
    gets.chomp
  end

  def go
    loop do
      puts ACTIONS
      case selected_option
      when 1 then create_station
      when 2 then create_train
      when 3 then create_change_route
      when 4 then set_route_for_train
      when 5 then add_vagons_for_train
      when 6 then delete_vagons
      when 7 then move_train
      when 8 then stations_trains_info
      when 9 then puts 'пока-пока'
        break
      else
        puts 'Неверная команда'
      end
    end
  end

  def create_station
    puts 'Введите наименовании станции'
    stations << Station.new(user_input)
    p stations
  end

  def create_train
    puts 'Выберете тип поезда', TRAIN_TYPES
    case selected_option
    when 1
      puts 'Введите номер грузового поезда:'
      new_train = CargoTrain.new(user_input)
      trains << new_train
      puts "Создан грузовой поезд с номером #{new_train.number}"
    when 2
      puts 'Введите номер пассажирского поезда:'
      new_train = PassengerTrain.new(user_input)
      trains << new_train
      puts "Создан пассажирский поезд с номером #{new_train.number}"
    else
      puts 'Неверная команда'
    end
  end

  def create_change_route
    puts 'Что делаем с маршрутом?', ROUTE_MENU
    case selected_option
    when 1 then create_route
    when 2 then add_between_station
    when 3 then delete_station
    else 
      puts 'Неверная команда'
    end
  end

  def show_stations
    stations.each_with_index { |station, index| puts "#{index} - #{station.name}" }
  end

  def show_routes
    routes.each_with_index { |route, index| puts "#{index} - #{route.stations.first.name} - #{route.stations.last.name}" }
  end

  def show_trains
    trains.each_with_index { |train, index| puts "#{index} - #{train.number} - #{train.type}"}
  end

  def show_vagons
    vagons.each_with_index { |vagon, index| puts "#{index} - #{vagon.type}"}
  end

  def create_route
    if stations.size < 2
      puts "Вы создали мало станций для маршрута. Минимум 2, создано - #{stations.size}. Создадим? [y/n]"
      create_station if ['y', 'Y'].include?(user_input)
    else 
      puts 'Давайте создадим маршрут. С какой станции отправимся?'
      show_stations
      from = selected_option
      puts 'До какой станции поедем?'
      show_stations
      to = selected_option
      routes << Route.new(stations[from], stations[to])
      puts 'Добавим промеждуточные станции? [y/n]'
      add_between_station if ['y', 'Y'].include?(user_input)
    end
  end

  def add_between_station
    if stations.size < 3
      puts "Для добавления промежуточной станции нужно 3 и более созданных станций. Создано - #{stations.size}. Создадим ещё одну? [y/n]"
      create_station if ['y', 'Y'].include?(user_input)
    elsif routes.empty?
      puts "Для добавления промежуточной станции нужно создать хотя бы один маршрут. Создадим? [y/n]"
      create_route if ['y', 'Y'].include?(user_input)
    else
      puts 'В какой маршрут добавим станцию?'
      show_routes
      route = routes[selected_option]
      puts 'Выберете станцию для добавления'
      show_stations
      station = stations[selected_option]
      route.add_station(station)
      puts 'Станция добавлена в маршрут'
    end
  end

  def delete_station
    puts 'Выберете маршрут, в котором хотите удалить станцию'
    show_routes
    route = routes[selected_option]
    puts 'Какую станцию хотите удалить?'
    show_stations
    station = stations[selected_option]
    route.delete_station(station)
  end

  def set_route_for_train
    unless routes.empty?
      puts 'Выбирите поезд'
      show_trains
      train = trains[selected_option]
      puts "По какому маршруту отправим поезд #{train.number}?"
      show_routes
      route = routes[selected_option]
      train.route = route
    else 
      puts 'Не создано ни одного маршрута. Создать? [y/n]'
      create_route if ['y', 'Y'].include?(user_input)
    end
  end

  def add_vagons_for_train
    unless trains.empty?
      puts 'Хотите создать вагон? [y/n]'
      create_vagon if ['y', 'Y'].include?(user_input) || vagons.empty?
      puts 'Выберете поезд для добавления вагона'
      show_trains
      selected_train = trains[selected_option]
      puts 'Выберете вагон для сцепки'
      show_vagons
      selected_vagon = vagons[selected_option]
      selected_train.attach_vagon(selected_vagon)
      puts 'Вагон прицеплен'
    else
      puts 'Для начала нужно создать поезд'
      create_train
    end
  end

  def delete_vagons
    puts 'С какого поезда будем отцеплять вагон?'
    show_trains
    selected_train = trains[selected_option]
    if selected_train.vagons.empty?
      puts 'У выбранного поезда нет вагонов'
    else
      selected_train.detach_vagon
      puts 'Вагон отцеплен'
    end
  end
    
  def create_vagon
    puts 'Какой тип вагона Вы хотите создать?', VAGON_TYPES
    case selected_option
    when 1 then 
      vagons << CargoVagon.new
      puts 'Создан грузовой вагон'
    when 2 then
      vagons << PassengerVagon.new
      puts 'Создан пассажирский вагон'
    else
      puts 'Неверная команда'
    end
  end

  def move_train
    puts 'Какой поезд переместим?'
    show_trains
    train = trains[selected_option]
    puts 'Куда перемещаем?', MOVE_TRAIN
    case selected_option
    when 1 then train.move_forward
    when 2 then train.move_backward
    else
      uts 'Неверная команда'
    end
  end

  def stations_trains_info
    puts 'Список станций:'
    show_stations
    puts 'Список поездов какой станции Вы хотите получить?'
    station = stations[selected_option]
    if station.trains.empty?
      puts 'На станции нет поездов'
    else
      puts "На станции #{station.name} следующие поезда:"
      puts station.trains
    end
  end
end

Main.new.go


    


