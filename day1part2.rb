file = File.open "day1in.txt"
sum = 0
max1 = 0
max2 = 0
max3 = 0
file.each_line do |l|
  if l == "\n"
    if sum > max1
      max1 = sum
    elsif sum > max2
      max2 = sum
    elsif sum > max3
      max3 = sum
    end
    sum = 0
  else
    sum += l.to_i
  end
end
file.close
puts max1 + max2 + max3