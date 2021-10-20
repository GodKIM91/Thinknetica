arr = []
(10..100).each { |value| arr << value if value % 5 == 0}
p arr