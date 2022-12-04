require 'set'

sum = 0
file = File.open "day3in.txt"
i = 0
map1 = {}
map2 = {}
map3 = {}
sum = 0
file.each_line do |l|
  l.strip!
  map = {}
  l.each_char do |c|
    map[c] = c
  end

  if i == 0
    map1 = map
  elsif i == 1
    map2 = map
  else
    map3 = map
  end

  i += 1

  if i == 3
    map1.each do |k, v|
      if map2.has_key? k
        if map3.has_key? k
          if k.ord < 97 # upper
            sum += (k.ord) - 64 + 26
          elsif
            sum += (k.ord) - 96
          end
        end
      end
    end
    i = 0
  end
end
file.close
puts sum