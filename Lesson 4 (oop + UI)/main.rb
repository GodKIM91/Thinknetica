require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'vagon'
require_relative 'cargo_vagon'
require_relative 'passenger_vagon'

puts 'Добрый вечер, Вы диспетчер! Выберете действие'

ACTIONS = <<~ACTIONS
  Выберете действие:
  1 - Создать станцию
  2 - Создать поезд
  3 - Создать маршрут и управлять станциями в нем (добавлять, удалять)
  4 - Назначить маршрут поезду
  5 - Добавить вагоны к поезду
  6 - Отцепить вагоны от поезда
  7 - Переместить поезд по маршруту вперед и назад
  8 - Просмостреть список станций и список поездов на станции
  9 - Просмотреть информацию о вагонах поезда
  10 - Заполнить вагон
  11 - Debug
  12 - Выход
ACTIONS

TRAIN_TYPES = <<~TYPES
  Выберете тип поезда:
  1 - Грузовой
  2 - Пассажирский
TYPES

MOVE_TRAIN = <<~MOVE
  Как переместим поезд:
  1 - Вперед
  2 - Назад
MOVE

VAGON_TYPES = <<~TYPES
  Выберете тип вагона:
  1 - Грузовой
  2 - Пассажирский
TYPES

ROUTE_MENU = <<~ROUTE_MENU
  Что делаем с маршрутом?
  1 - Создать маршрут
  2 - Добавить промежуточную точку
  3 - Удалить промеждуточную точку
ROUTE_MENU

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

  def success(info = nil)
    puts "\nDone: #{info}\n"
  end

  def make_choise(menu = nil)
    puts menu if menu
  end

  def go
    loop do
      make_choise(ACTIONS)
      case selected_option
      when 1 then create_station
      when 2 then create_train
      when 3 then create_change_route
      when 4 then set_route_for_train
      when 5 then add_vagons_for_train
      when 6 then delete_vagons
      when 7 then move_train
      when 8 then stations_trains_info
      when 9 then show_vagons_info
      when 10 then fill_vagon
      when 11 then binding.irb
      when 12 then puts 'пока-пока'
                   break
      else
        raise ArgumentError, 'Wrong command. Try 1-10'
      end
    end
  rescue ArgumentError => e
    p "ERROR: #{e.message}"
    retry
  end

  def create_station
    puts 'Введите наименовании станции'
    stations << Station.new(user_input)
    success(stations.last)
  rescue RuntimeError => e
    p "ERROR: #{e.message}"
    retry
  end

  def create_train
    make_choise(TRAIN_TYPES)
    case selected_option
    when 1
      p 'Введите номер для грузового поезда:'
      new_train = CargoTrain.new(user_input)
    when 2
      p 'Введите номер для пассажирского поезда:'
      new_train = PassengerTrain.new(user_input)
    else
      raise ArgumentError, 'Wrong command. Try 1-2'
    end
    trains << new_train
    success(new_train)
  rescue ArgumentError => e
    p "ERROR: #{e.message}"
    retry
  rescue RuntimeError => e
    p "ERROR: #{e.message}"
    retry
  end

  def create_change_route
    make_choise(ROUTE_MENU)
    case selected_option
    when 1 then create_route
    when 2 then add_between_station
    when 3 then delete_station
    else
      raise ArgumentError, 'Wrong command. Try 1-3'
    end
  rescue ArgumentError => e
    p "ERROR: #{e.message}"
    retry
  end

  def show_stations
    stations.each_with_index { |station, index| puts "#{index} - #{station.name}" }
  end

  def show_routes
    routes.each_with_index do |route, index|
      puts "#{index} - #{route.stations.first.name} - #{route.stations.last.name}"
    end
  end

  def show_trains
    trains.each_with_index { |train, index| puts "#{index} - #{train.number} - #{train.type}" }
  end

  def show_vagons
    vagons.each_with_index { |vagon, index| puts "#{index} - #{vagon.type}" }
  end

  def create_route
    if stations.size < 2
      puts "Вы создали мало станций для маршрута. Минимум 2, создано - #{stations.size}. Создадим? [y/n]"
      create_station if %w[y Y].include?(user_input)
    else
      puts 'Давайте создадим маршрут. С какой станции отправимся?'
      show_stations
      from = selected_option
      puts 'До какой станции поедем?'
      show_stations
      to = selected_option
      routes << Route.new(stations[from], stations[to])
      success(routes.last)
      puts 'Добавим промежуточные станции? [y/n]'
      add_between_station if %w[y Y].include?(user_input)
    end
  end

  def add_between_station
    if stations.size < 3
      puts "Для добавления промежуточной станции нужно 3 и более созданных станций. Создано - #{stations.size}. Создадим ещё одну? [y/n]"
      create_station if %w[y Y].include?(user_input)
    elsif routes.empty?
      puts 'Для добавления промежуточной станции нужно создать хотя бы один маршрут. Создадим? [y/n]'
      create_route if %w[y Y].include?(user_input)
    else
      puts 'В какой маршрут добавим станцию?'
      show_routes
      route = routes[selected_option]
      puts 'Выберете станцию для добавления'
      show_stations
      route.add_station(stations[selected_option])
    end
  end

  def delete_station
    puts 'Выберете маршрут, в котором хотите удалить станцию'
    show_routes
    route = routes[selected_option]
    puts 'Какую станцию хотите удалить?'
    show_stations
    route.delete_station(stations[selected_option])
  end

  def set_route_for_train
    if routes.empty?
      puts 'Не создано ни одного маршрута. Создать? [y/n]'
      create_route if %w[y Y].include?(user_input)
    else
      puts 'Выбирите поезд'
      show_trains
      train = trains[selected_option]
      puts "По какому маршруту отправим поезд #{train.number}?"
      show_routes
      train.route = routes[selected_option]
    end
  end

  def add_vagons_for_train
    if trains.empty?
      puts 'Для начала нужно создать поезд'
      create_train
    else
      puts 'Хотите создать вагон? [y/n]'
      create_vagon if %w[y Y].include?(user_input) || vagons.empty?
      puts 'Выберете поезд для добавления вагона'
      show_trains
      selected_train = trains[selected_option]
      puts 'Выберете вагон для сцепки'
      show_vagons
      selected_train.attach_vagon(vagons[selected_option])
      puts 'Вагон прицеплен'
    end
  rescue RuntimeError => e
    p "ERROR: #{e.message}"
    retry
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
    make_choise(VAGON_TYPES)
    case selected_option
    when 1
      puts 'Введите вместимость грузового вагона (50..150 куб.м)'
      total_place = selected_option
      if total_place.between?(50, 150)
        vagons << CargoVagon.new(total_place)
        success(vagons.last)
      else
        raise ArgumentError, 'Wrong space of cargo vagon. Try 50..150'
      end
    when 2
      puts 'Введите количество мест пассажирского вагона (60-90)'
      total_place = selected_option
      if total_place.between?(60, 90)
        vagons << PassengerVagon.new(total_place)
        success(vagons.last)
      else
        raise ArgumentError, 'Wrong places q-ty for passenger vagon. Try 60-90'
      end
    else
      raise ArgumentError, 'Wrong command. Try 1-2'
    end
  rescue ArgumentError => e
    p "ERROR: #{e.message}"
    retry
  end

  def fill_vagon
    create_vagon if vagons.empty?
    puts 'Выберете вагон для заполнения'
    show_vagons
    vagon = vagons[selected_option]
    case vagon.type
    when 'cargo'
      puts "В грузовом вагоне свободно #{vagon.free_place} куб.м3. Какой объем займем?"
      value = selected_option
      if value <= vagon.free_place
        vagon.reduce_place(value)
        puts "Вагон загружен. Остаток свободного места #{vagon.free_place}"
      else
        raise ArgumentError, 'В вагоне недостаточно места'
      end
    when 'passenger'
      puts "В пассажирском вагоне свободно #{vagon.free_place} мест."
      if vagon.free_place >= 1
        vagon.book_seat
        puts "Пассажир сел. Остаток свободных мест #{vagon.free_place}"
      else
        raise ArgumentError, 'В вагоне недостаточно мест'
      end
    end
  rescue ArgumentError => e
    p "ERROR: #{e.message}"
    retry
  end

  def show_vagons_info
    puts 'Список вагонов какого поезда Вы хотите увидеть?'
    show_trains
    train = trains[selected_option]
    train.vagons.empty? ? raise('У этого поезда нет вагонов') : train.each_vagon { |vagon| puts vagon }
  rescue RuntimeError => e
    p "ERROR: #{e.message}"
    go
  end

  def move_train
    puts 'Какой поезд переместим?'
    show_trains
    train = trains[selected_option]
    make_choise(MOVE_TRAIN)
    case selected_option
    when 1 then train.move_forward
    when 2 then train.move_backward
    else
      raise ArgumentError, 'Wrong command. Try 1-2'
    end
  rescue ArgumentError => e
    p "ERROR: #{e.message}"
    retry
  end

  def stations_trains_info
    show_stations
    puts 'Список поездов какой станции Вы хотите получить?'
    station = stations[selected_option]
    if station.trains.empty?
      puts 'На станции нет поездов'
    else
      puts "На станции #{station.name} следующие поезда:"
      station.each_train { |train| puts train }
    end
  end
end

Main.new.go
