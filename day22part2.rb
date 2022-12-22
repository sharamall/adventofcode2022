# http://www.abdulbaki.org/Unfolding_A_Cube.html
file = File.open "day22in.txt"
$grid = []
$commands = []
reading_grid = true
start_x = nil
max_x = 0
$dirs = [:right, :down, :left, :up]
$block_size = nil

def numeric?(v)
  v.to_i.to_s == v.to_s
end

def print_grid(pos)
  $grid.length.times do |y|
    $grid[y].each_with_index do |x, x_index|
      if x_index == pos[0] && y == pos[1]
        print ">" if $dir_index == 0
        print "v" if $dir_index == 1
        print "<" if $dir_index == 2
        print "^" if $dir_index == 3
      else
        print x unless x.nil?
        print " " if x.nil?
      end
    end
    print "\n"
  end
  print "\n"
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
      $commands << { move: r[0].to_i } if numeric? r[0]
      $commands << { turn: r[1] }
    end
    i = -1
    last_val = ""
    while numeric? l[i]
      last_val = l[i] + last_val
      i -= 1
    end
    $commands << { move: last_val.to_i }
  end
end

$grid.each do |l|
  (l.length...max_x).each { l << nil } unless l.length == max_x
end

def block_pos_to_coords(block_pos)
  x = block_pos[0] * ($grid[0].length / 3)
  y = block_pos[1] * ($grid.length / 4)
  [x, y]
end

def coords_to_block_pos(pos)
  block_x = pos[0] / ($grid[0].length / 3)
  block_y = pos[1] / ($grid.length / 4)
  [block_x, block_y]
end

def block_present(block_pos)
  block_x, block_y = block_pos_to_coords(block_pos)
  not $grid[block_y][block_x].nil?
end

$rotations = 0
$v_flipped = false
$h_flipped = false

def detect_fold_type(pos)
  # 11 folds https://i.stack.imgur.com/bKeeJ.jpg
  raise "5 height not supported" if $grid[0].length * 2 < $grid.length
  if $grid[0].length > $grid.length
    $grid = $grid.transpose.map(&:reverse)
    raise "5 height not supported" if $grid[0].length * 2 < $grid.length
    $rotations += 1
    $dir_index += 1
    pos = [$grid[0].length - 1, pos[0]]
  end
  $block_size = $grid[0].length / 3
  #  tested by hand...
  if block_present([0, 2]) || block_present([0, 3]) ||
    (block_present([0, 1]) && block_present([2, 3]) && block_present([1, 3])) ||
    block_present([2, 0]) && block_present([2, 1])
    # need to rotate||flip
    if block_present([2, 3]) && !block_present([0, 3])
      # rotate twice
      $grid = $grid.transpose.map(&:reverse)
      $grid = $grid.transpose.map(&:reverse)
      $rotations += 2
      pos[0] = $grid[0].length - pos[0] - 1
      pos[1] = $grid.length - pos[1] - 1
    elsif block_present([0, 1]) && block_present([2, 0]) ||
      (!block_present([0, 0]) && !(block_present([0, 1])) && !(block_present([0, 2]) && block_present([2, 2])))
      $h_flipped = true
      $grid.each(&:reverse!)
      $commands.each do |c|
        if c.key? :turn
          if c[:turn] == "L"
            c[:turn] = "R"
          else
            c[:turn] = "L" if c[:turn] == "R"
          end
        end
      end
      pos[0] = $grid[0].length - pos[0] - 1
      $dir_index = ($dir_index + 2) % $dirs.length
    else
      # flip on equator
      $v_flipped = true
      $grid.reverse!
      pos[1] = $grid.length - pos[1] - 1
      $dir_index = ($dir_index + 2) % $dirs.length
    end
  end
  case
  when block_present([0, 0]) && block_present([1, 0]) && block_present([2, 2]) && block_present([2, 3])
  then
    # ..
    #  $
    #  ..
    #   .
    # base
    $mappings["11_left"] = [[0, 0], :up]
    $mappings["11_right"] = [[2, 2], :down]
    $mappings["11_up"] = [[1, 0], :up]
    $mappings["11_down"] = [[1, 2], :down]
    # top left
    $mappings["00_left"] = [[1, 2], :right]
    $mappings["00_right"] = [[1, 0], :right]
    $mappings["00_up"] = [[2, 3], :up]
    $mappings["00_down"] = [[1, 1], :right]
    # top mid
    $mappings["10_left"] = [[0, 0], :left]
    $mappings["10_right"] = [[2, 2], :left]
    $mappings["10_up"] = [[2, 3], :left]
    $mappings["10_down"] = [[1, 1], :down]
    # middle middle
    $mappings["12_left"] = [[0, 0], :right]
    $mappings["12_right"] = [[2, 2], :right]
    $mappings["12_up"] = [[1, 1], :up]
    $mappings["12_down"] = [[2, 3], :right]
    # right down
    $mappings["22_left"] = [[1, 2], :left]
    $mappings["22_right"] = [[1, 0], :left]
    $mappings["22_up"] = [[1, 1], :left]
    $mappings["22_down"] = [[2, 3], :down]
    # right down down
    $mappings["23_left"] = [[1, 2], :up]
    $mappings["23_right"] = [[1, 0], :down]
    $mappings["23_up"] = [[2, 2], :up]
    $mappings["23_down"] = [[0, 0], :down]
  when block_present([0, 0]) && block_present([0, 1]) && block_present([2, 1])
  then
    # .
    # .$.
    #  .
    #  .
    # base
    $mappings["11_left"] = [[0, 1], :left]
    $mappings["11_right"] = [[2, 1], :right]
    $mappings["11_up"] = [[0, 0], :left]
    $mappings["11_down"] = [[1, 2], :down]
    # left
    $mappings["01_left"] = [[1, 3], :right]
    $mappings["01_right"] = [[1, 1], :right]
    $mappings["01_up"] = [[0, 0], :up]
    $mappings["01_down"] = [[1, 2], :right]
    # right
    $mappings["21_left"] = [[1, 1], :left]
    $mappings["21_right"] = [[1, 3], :left]
    $mappings["21_up"] = [[0, 0], :down]
    $mappings["21_down"] = [[1, 2], :left]
    # top left
    $mappings["00_left"] = [[1, 3], :up]
    $mappings["00_right"] = [[1, 1], :down]
    $mappings["00_up"] = [[2, 1], :down]
    $mappings["00_down"] = [[0, 1], :down]
    # middle middle
    $mappings["12_left"] = [[0, 1], :up]
    $mappings["12_right"] = [[2, 1], :up]
    $mappings["12_up"] = [[1, 1], :up]
    $mappings["12_down"] = [[1, 3], :down]
    # down middle
    $mappings["13_left"] = [[0, 1], :right]
    $mappings["13_right"] = [[2, 1], :left]
    $mappings["13_up"] = [[1, 2], :up]
    $mappings["13_down"] = [[0, 0], :right]
  else
    raise "oop"
  end
  $mappings
  pos
end

$dir_index = 0
$mappings = {}
pos = detect_fold_type([start_x, 0])

def next_pos_and_dir(pos, dir)
  x = pos[0]
  y = pos[1]
  block = coords_to_block_pos(pos)
  if dir == :right || dir == :left
    d = 1
    d = -1 if dir == :left

    new_block = coords_to_block_pos([x + d, y])
    if new_block == block # we don't actually go to the new block, we go to the mapped block
      x += d if $grid[y][x + d] != "#"
      return { x: x, y: y, dir: $dirs.find_index(dir) }
    else
      mapping = $mappings["#{block[0]}#{block[1]}_#{dir}"]
      new_dir = mapping[1]
      new_coords = block_pos_to_coords(mapping[0])
      if dir == new_dir
        new_coords[0] += $block_size - (x % $block_size) - 1
        new_coords[1] += y % $block_size
      elsif dir == :left and new_dir == :right
        # x stays y, y flips
        new_coords[0] += 0
        new_coords[1] += $block_size - (y % $block_size) - 1
      elsif dir == :right and new_dir == :up
        new_coords[0] += y % $block_size
        new_coords[1] += $block_size - 1 # bottom
      elsif dir == :right and new_dir == :down
        new_coords[0] += $block_size - (y % $block_size) - 1
        new_coords[1] += 0 # top
      elsif dir == :right and new_dir == :left
        new_coords[0] += x % $block_size # right
        new_coords[1] += $block_size - (y % $block_size) - 1 # inverse from top
      elsif dir == :left and new_dir == :up
        new_coords[0] += $block_size - (y % $block_size) - 1
        new_coords[1] += $block_size - 1
      else
        puts "todo dir: #{dir}, new_dir: #{new_dir}"
      end
      if $grid[new_coords[1]][new_coords[0]] == "#"
        return { x: x, y: y, dir: $dirs.find_index(dir) }
      else
        return { x: new_coords[0], y: new_coords[1], dir: $dirs.find_index(new_dir) }
      end
    end
  elsif dir == :down || dir == :up
    d = 1
    d = -1 if dir == :up
    new_block = coords_to_block_pos([x, y + d])
    if new_block == block # we don't actually go to the new block, we go to the mapped block
      y += d if $grid[y + d][x] != "#"
      return { x: x, y: y, dir: $dirs.find_index(dir) }
    else
      mapping = $mappings["#{block[0]}#{block[1]}_#{dir}"]
      new_dir = mapping[1]
      new_coords = block_pos_to_coords(mapping[0])
      if dir == :down and new_dir == :left
        # convert x position to length - y - 1 position
        new_coords[0] += $block_size - 1
        new_coords[1] += x % $block_size
      elsif dir == new_dir
        new_coords[0] += x % $block_size
        new_coords[1] += $block_size - (y % $block_size) - 1
      elsif dir == :up and new_dir == :left
        new_coords[0] += $block_size - 1
        new_coords[1] += $block_size - (x % $block_size) - 1
      elsif dir == :down and new_dir == :right
        new_coords[0] += 0
        new_coords[1] += $block_size - (x % $block_size) - 1
      else
        puts "todo dir: #{dir}, new_dir: #{new_dir}"
      end
      if $grid[new_coords[1]][new_coords[0]] == "#"
        return { x: x, y: y, dir: $dirs.find_index(dir) }
      else
        return { x: new_coords[0], y: new_coords[1], dir: $dirs.find_index(new_dir) }
      end
    end
  end
end

$commands.each_with_index do |c, index|
  if c.key? :move
    j = c[:move]
    until j == 0
      pos_dir = next_pos_and_dir(pos, $dirs[$dir_index])
      j -= 1
      if pos_dir[:x] == pos[0] and pos_dir[:y] == pos[1] and $dir_index == pos_dir[:dir]
        j = 0
      end
      pos[0] = pos_dir[:x]
      pos[1] = pos_dir[:y]
      $dir_index = pos_dir[:dir]
    end
  else
    turn = c[:turn]
    dir = 1
    dir = -1 if turn == "L"
    dir *= -1 if $v_flipped
    $dir_index = ($dir_index + dir + $dirs.length) % $dirs.length
  end
end

# print_grid pos
x = pos[0]
y = pos[1]
if $rotations == 1
  x = y
  y = $grid[0].length - pos[0] - 1
  x = $grid.length - pos[1] - 1 if $v_flipped
elsif $rotations == 0
  x = $grid[0].length - x - 1 if $h_flipped
end
x += 1
y += 1
$dir_index += $rotations
$dir_index += 2 if $h_flipped and $dir_index % 2 == 0 # swap left/right
$dir_index += 2 if $v_flipped and $dir_index % 2 == 1 # swap up/down
$dir_index %= $dirs.length

puts "score #{1000 * y + 4 * x + $dir_index}"