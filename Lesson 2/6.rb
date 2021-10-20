items = {}
loop do
  puts "Введите наименование товара:"
  name = gets.chomp.to_s
  break if name == 'стоп'
  puts "Введите цену:"
  priсe = gets.chomp.to_f
  puts "Введите количество:"
  qty = gets.chomp.to_f
  items[name] = {priсe => qty}
end

p items
total_price = 0

items.each do |item, params|
  params.each do |price, qty|
    puts "Стоимость #{item} равна #{price * qty} руб"
    total_price += price * qty
  end
end

puts "Итоговая стоимость покупок составляет #{total_price} руб."