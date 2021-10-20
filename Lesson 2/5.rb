puts "Введите сегодняшнее число:"
day = gets.chomp.to_i
puts "Введите номер месяца:"
month = gets.chomp.to_i
puts "Введите год:"
year = gets.chomp.to_i

months = {1 => 31, 2 => 28, 3 => 31, 4 => 30, 5 => 31, 6 => 30, 7 => 31, 8 => 31, 9 => 30, 10 => 31, 11 => 30, 12 => 31 }
months[2] = 29 if year % 4 == 0 || year % 400 == 0 #увеличиваем число дней в феврале, если год високосный
months[month] = day #в хеше с месяцами подменяем значение пользовательского месяца на пользовательское число
passed_days = 0

months.each do |k,v|
  passed_days += v if k <= month
end

p passed_days
