
file = File.open "day2in.txt"
score = 0
file.each_line do |l|
  arr = l.split
  if arr[0] == 'A'
    if arr[1] == 'X'
      score += 3
      score += 1
    elsif arr[1] == 'Y'
      score += 6
      score += 2
    else
      score += 0
      score += 3
    end
  elsif arr[0] == 'B'
    if arr[1] == 'X'
      score += 0
      score += 1
    elsif arr[1] == 'Y'
      score += 3
      score += 2
    else
      score += 6
      score += 3
    end
  elsif arr[0] == 'C'
    if arr[1] == 'X'
      score += 6
      score += 1
    elsif arr[1] == 'Y'
      score += 0
      score += 2
    else
      score += 3
      score += 3
    end
  end
end
puts score