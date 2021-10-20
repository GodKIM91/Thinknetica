hash = {}
count = 1
("a".."z").each do |elem|
  hash[elem] = count
  count+=1
end

p hash.delete_if { |k, v| k.match?(/[qwrtpsdfghjklzxcvbnm]/)}
