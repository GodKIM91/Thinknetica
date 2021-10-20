arr = [0,1]

while arr[-1] + arr[-2] < 100 do
  arr << arr[-1] + arr[-2]
end

p arr