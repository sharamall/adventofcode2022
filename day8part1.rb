file = File.open "day8in.txt"
grid = []
line = 0
file.each_line do |l|
  grid << []
  l.chomp.each_char { |c| grid[line] << c.to_i }
  line += 1
end
file.close
passes = grid[0].length * 2 + (grid.length - 2) * 2

(1..(grid.length - 2)).each do |y|
  (1..(grid[0].length - 2)).each do |x|
    cur = grid[y][x]
    fail_up = false
    fail_down = false
    fail_left = false
    fail_right = false
    (0..(y - 1)).each do |up|
      if grid[up][x] >= cur
        fail_up = true
        break
      end
    end
    ((y + 1)..(grid.length - 1)).each do |down|
      if grid[down][x] >= cur
        fail_down = true
        break
      end
    end
    (0..(x - 1)).each do |left|
      if grid[y][left] >= cur
        fail_left = true
        break
      end
    end
    ((x + 1)..(grid[0].length - 1)).each do |right|
      if grid[y][right] >= cur
        fail_right = true
        break
      end
    end
    pass = (fail_up and fail_down and fail_left and fail_right)
    pass = !pass
    passes += 1 if pass
  end
end
puts passes