require_relative 'route'
require_relative 'station'
require_relative 'train'

#создаем станции
st1 = Station.new('Kukushkino-1')
st2 = Station.new('Medvedkovo-2')
st3 = Station.new('Domodedovo-3')
st4 = Station.new('Podolskaya-4')

#создаем маршруты
rt1 = Route.new(st1, st4)
rt2 = Route.new(st2, st1)

#добавляем в маршрут st1-st4 промежуточную станцию st3
rt1.add_between_point(st3)
#выводим маршрус
puts "Маршрут rt1: #{rt1.route_points}"
#создаем поезда
train_types = ['грузовой', 'пассажирский']
tr1 = Train.new('GRUZ_ONE', train_types[0], 37)
tr2 = Train.new('GRUZ_TWO', train_types[0], 24)
tr3 = Train.new('PASS_ONE', train_types[1], 13)

tr1.route = rt1
tr2.route = rt1
tr3.route = rt2

#проверяем сцепку/отцепку вагонов и управление скоростью
puts "***Проверяем сцепку/отцепку вагонов и управление скоростью***"
tr3.increase_speed(50)
tr3.attach_vagon
puts tr3.vagons_count
tr3.detach_vagon
puts tr3.vagons_count
tr3.break_speed
tr3.attach_vagon
puts tr3.vagons_count
tr3.detach_vagon
puts tr3.vagons_count

#проверяем перемещение поездов
puts "***Проверяем перемещение поездов***"
puts tr1.next_station
tr1.move_forward
puts tr1.next_station
puts tr1.previous_station
tr1.move_backward

#проверяем количество поездов на станциях и сколько каждого типа
puts "***Проверяем количество поездов на станциях и сколько каждого типа***"
puts "     На первой станции:"
puts st1.trains
puts "     На второй станции:"
puts st2.trains
puts "     На первой станции следующие грузовые поезда:"
puts st1.trains_by_type(train_types[0])
puts "     На второй станции следующие грузовые поезда:"
puts st2.trains_by_type(train_types[1])