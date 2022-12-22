file = File.open "day22in.txt"
$grid = []
commands = []
reading_grid = true
start_x = nil
max_x = 0
dirs = [:right, :down, :left, :up]

def numeric?(v)
  v.to_i.to_s == v.to_s
end

file.each_with_index do |l, line_num|
  if l.chomp.empty?
    reading_grid = false
    next
  end
  if reading_grid
    l.chomp!
    max_x = l.length if l.length > max_x
    $grid << []
    l.chars.each_with_index do |c, c_index|
      $grid[line_num] << nil if c == " "
      unless c == " "
        $grid[line_num] << c
        start_x = c_index if start_x.nil?
      end
    end
  else
    results = l.scan /(\d+)([RL])/
    results.each do |r|
      commands << { move: r[0].to_i } if numeric? r[0]
      commands << { turn: r[1] }
    end
    i = -1
    last_val = ""
    while numeric? l[i]
      last_val = l[i] + last_val
      i -= 1
    end
    commands << { move: last_val.to_i }
  end
end

$grid.each do |l|
  (l.length...max_x).each { l << nil } unless l.length == max_x
end
dir_index = 0
pos = [start_x, 0]

def next_index(pos, dir)
  x = pos[0]
  y = pos[1]
  if dir == :right or dir == :left
    d = 1
    d = -1 if dir == :left
    return x + d if x + d < $grid[y].length and x + d >= 0 and $grid[y][x + d] == "."
    return x if x + d < $grid[y].length and x + d >= 0 and $grid[y][x + d] == "#"
    index = (x + d) % $grid[y].length
    index = (index + d + $grid[y].length) % $grid[y].length while $grid[y][index].nil?
    return x if $grid[y][index] == "#" # wall on other side of teleport
    index
  elsif dir == :down or dir == :up
    d = 1
    d = -1 if dir == :up
    return y + d if y + d < $grid.length and y + d >= 0 and $grid[y + d][x] == "."
    return y if y + d < $grid.length and y + d >= 0 and $grid[y + d][x] == "#"
    index = (y + d) % $grid.length
    index = (index + d + $grid.length) % $grid.length while $grid[index][x].nil?
    return y if $grid[index][x] == "#" # wall on other side of teleport
    index
  end
end

def print_grid(pos)
  $grid.length.times do |y|
    $grid[y].each_with_index do |x, x_index|
      if x_index == pos[0] and y == pos[1]
        print "™"
      else
        print x unless x.nil?
        print " " if x.nil?
      end
    end
    puts ""
  end
  puts ""
end

# print_grid(pos)

commands.each_with_index do |c, index|
  if c.key? :move
    if dir_index == 0 or dir_index == 2
      j = c[:move]
      until j == 0
        i = next_index(pos, dirs[dir_index])
        j -= 1
        j = 0 if i == pos[0]
        pos[0] = i
      end
    else
      j = c[:move]
      until j == 0
        i = next_index(pos, dirs[dir_index])
        j -= 1
        j = 0 if i == pos[1]
        pos[1] = i
      end
    end
  else
    turn = c[:turn]
    dir = 1
    dir = -1 if turn == "L"
    dir_index = (dir_index + dir + dirs.length) % dirs.length
  end
end

# print_grid(pos)

puts (pos[1] + 1) * 1000 + (pos[0] + 1) * 4 + dir_index
