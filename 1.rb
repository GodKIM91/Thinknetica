puts "Как Вас зовут?"
name = gets.chomp.capitalize
puts "Каков Ваш рост?"
height = gets.chomp.to_i
weight = (height - 110) * 1.15

if weight < 0 
    puts "Ваш вес уже оптимальный"
else
    puts "#{name}, Ваш идеальный вес - #{weight} кг"
end