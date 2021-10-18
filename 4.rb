puts "Введите к-т a"
a = gets.chomp.to_i
puts "Введите к-т b"
b = gets.chomp.to_i
puts "Введите к-т c"
c = gets.chomp.to_i

d = b**2 - 4 * a * c

if d < 0
    puts "Корней нет"
elsif d > 0
    x1 = (-b + Math.sqrt(d)) / (2 * a)
    x2 = (-b - Math.sqrt(d)) / (2 * a)
    puts "D = #{d}, x1 = #{x1}, x2 = #{x2}"
elsif d == 0
    x = (-b + Math.sqrt(d)) / (2 * a)
    puts "D = #{d}, x = #{x}"
end