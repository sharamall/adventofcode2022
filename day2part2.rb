
file = File.open "day2in.txt"
score = 0
# w l d
# 6 0 3
#
# r p s
# 1 2 3
#
# a b c
# r p s
#
# x y z
# l d w
file.each_line do |l|
  arr = l.split
  if arr[0] == 'A'
    if arr[1] == 'X' # lose
      score += 0
      score += 3
    elsif arr[1] == 'Y' # draw
      score += 3
      score += 1
    else # win
      score += 6
      score += 2
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
      score += 0
      score += 2
    elsif arr[1] == 'Y'
      score += 3
      score += 3
    else
      score += 6
      score += 1
    end
  end
end
file.close
puts score