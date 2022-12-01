file = File.open "day1in.txt"
sum = 0
max = 0
file.each_line do |l|
  if l == "\n"
    if sum > max
      max = sum
    end
    sum = 0
  else
    sum += l.to_i
  end
end
puts max