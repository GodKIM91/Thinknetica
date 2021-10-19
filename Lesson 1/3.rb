puts "Введите сторону a"
a = gets.chomp.to_i
puts "Введите сторону b"
b = gets.chomp.to_i
puts "Введите сторону c"
c = gets.chomp.to_i

if a == b && b == c
  puts "Треугольник равносторонний и равнобедренный"
elsif a == b || b == c || c == a
  puts "Треугольник равнобедренный"
elsif a^2 == b^2 + c^2 || b^2 == a^2 + c^2 || c^2 == a^2 + b^2
  puts "Треугольник прямоугольный"
else 
  puts "Треугольник обычный"
end
