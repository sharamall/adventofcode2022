file = File.open "day8in.txt"
grid = []
scenic = []
line = 0
file.each_line do |l|
  grid << []
  scenic << []
  l.chomp.each_char do |c|
    grid[line] << c.to_i
    scenic[line] << 0
  end
  line += 1
end
file.close

(1..(grid.length - 2)).each do |y|
  (1..(grid[0].length - 2)).each do |x|
    cur = grid[y][x]
    trees_up = 0
    trees_down = 0
    trees_left = 0
    trees_right = 0
    (0..(y - 1)).reverse_each do |up|
      trees_up += 1
      if grid[up][x] >= cur
        break
      end
    end
    ((y + 1)..(grid.length - 1)).each do |down|
      trees_down += 1
      if grid[down][x] >= cur
        break
      end
    end
    (0..(x - 1)).reverse_each do |left|
      trees_left += 1
      if grid[y][left] >= cur
        break
      end
    end
    ((x + 1)..(grid[0].length - 1)).each do |right|
      trees_right += 1
      if grid[y][right] >= cur
        break
      end
    end

    scenic[y][x] = trees_up * trees_down * trees_left * trees_right
  end
end
max_scenic = 0

(1..(grid.length - 2)).each do |y|
  (1..(grid[0].length - 2)).each do |x|
    max_scenic = scenic[y][x] if scenic[y][x] > max_scenic
  end
end
puts "maaaax Clueless #{max_scenic}"