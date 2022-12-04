require 'set'

sum = 0
file = File.open "day3in.txt"
file.each_line do |l|
  first_ = l[0...(l.length / 2)]
  second_ = l[(l.length / 2)..l.length]
  first_map = {}
  second_map = {}

  first_.each_char do |e|
    first_map[e] = e
  end

  second_.each_char do |e|
    second_map[e] = e
  end

  first_map.each do |k, v|
    if second_map.has_key? k
      puts "shared #{k}"
      if k.ord < 97 # upper
        sum += (k.ord) - 64 + 26
      elsif
        sum += (k.ord) - 96
      end
    end
  end

end
file.close
puts sum