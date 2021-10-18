puts "Введите длину основания:"
a = gets.chomp.to_f
puts "Введите длину высоты:"
h = gets.chomp.to_f
s = 0.5*a*h
puts "Площадь треугольника равна #{s.round(2)}"