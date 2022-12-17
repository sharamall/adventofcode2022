file = File.open "day17in.txt"
moves = []
file.each_char { |c| moves << c }
file.close
$move_index = 0
grid = [%w[_ _ _ _ _ _ _]]
$highest_point = 1
$reset_offset = 0

def add_blank_row(grid)
  grid << []
  7.times do |x|
    grid[-1] << "."
  end
end

3.times do |y|
  add_blank_row grid
end
shape_key = 0

def print_grid(grid)
  grid.reverse_each do |row|
    print "|"
    row.each { |c| print c }
    print "|"
    puts ""
  end
  puts ""
end

class Shape
  @pos

  def initialize(grid) end

  def place!(grid) end

  def fall?(grid)
    false
  end

  def fall!(grid) end

  def shift_left?(grid)
    false
  end

  def shift_right?(grid)
    false
  end

  def shift_left!(grid)
    false
  end

  def shift_right!(grid)
    false
  end

  def top_resting_height

  end

  def shape_vertical_size

  end
end

class HorizontalBar < Shape
  def initialize(grid)
    @pos = [2, 0]
  end

  def place!(grid)
    @pos[1] += [grid.length - $highest_point - 3 - shape_vertical_size, 0].max
    4.times { |i| grid[grid.length - 1 - @pos[1]][i + @pos[0]] = '#' }
  end

  def fall?(grid)
    grid[grid.length - 2 - @pos[1]][@pos[0]] == "." and
      grid[grid.length - 2 - @pos[1]][@pos[0] + 1] == "." and
      grid[grid.length - 2 - @pos[1]][@pos[0] + 2] == "." and
      grid[grid.length - 2 - @pos[1]][@pos[0] + 3] == "."
  end

  def fall!(grid)
    4.times do |i|
      grid[grid.length - @pos[1] - 1][i + @pos[0]] = '.'
    end
    4.times do |i|
      grid[grid.length - @pos[1] - 2][i + @pos[0]] = '#'
    end
    @pos[1] += 1
  end

  def shift_left?(grid)
    @pos[0] > 0 and grid[grid.length - @pos[1] - 1][@pos[0] - 1] != '#'
  end

  def shift_left!(grid)
    4.times do |i|
      grid[grid.length - 1 - @pos[1]][i + @pos[0]] = '.'
    end
    4.times do |i|
      grid[grid.length - 1 - @pos[1]][i + @pos[0] - 1] = '#'
    end
    @pos[0] -= 1
  end

  def shift_right?(grid)
    @pos[0] < 3 and grid[grid.length - 1 - @pos[1]][@pos[0] + 4] != '#'
  end

  def shift_right!(grid)
    4.times do |i|
      grid[grid.length - 1 - @pos[1]][i + @pos[0]] = '.'
    end
    4.times do |i|
      grid[grid.length - 1 - @pos[1]][i + @pos[0] + 1] = '#'
    end
    @pos[0] += 1
  end

  def top_resting_height
    @pos[1]
  end

  def shape_vertical_size
    1
  end
end

class Cross < Shape

  def initialize(grid)
    @pos = [3, 2] # index
  end

  def place!(grid)
    @pos[1] += [grid.length - $highest_point - 3 - shape_vertical_size, 0].max
    grid[grid.length + 1 - @pos[1]][@pos[0] + 0] = '#'
    grid[grid.length + 0 - @pos[1]][@pos[0] - 1] = '#'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 0] = '#'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 1] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0] = '#'
  end

  def fall?(grid)
    grid[grid.length - 1 - @pos[1]][@pos[0] - 1] == "." and
      grid[grid.length - 1 - @pos[1]][@pos[0] + 1] == "." and
      grid[grid.length - 2 - @pos[1]][@pos[0] + 0] == "."
  end

  def fall!(grid)
    grid[grid.length + 1 - @pos[1]][@pos[0] + 0] = '.'
    grid[grid.length + 0 - @pos[1]][@pos[0] - 1] = '.'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 0] = '.'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 1] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0] = '.'

    grid[grid.length + 1 - @pos[1] - 1][@pos[0] + 0] = '#' # top
    grid[grid.length + 0 - @pos[1] - 1][@pos[0] - 1] = '#'
    grid[grid.length + 0 - @pos[1] - 1][@pos[0] + 0] = '#'
    grid[grid.length + 0 - @pos[1] - 1][@pos[0] + 1] = '#'
    grid[grid.length - 1 - @pos[1] - 1][@pos[0] + 0] = '#' # bottom
    @pos[1] += 1
  end

  def shift_left?(grid)
    @pos[0] > 1 and
      grid[grid.length + 1 - @pos[1]][@pos[0] - 1] == "." and
      grid[grid.length + 0 - @pos[1]][@pos[0] - 2] == "." and
      grid[grid.length - 1 - @pos[1]][@pos[0] - 1] == "."
  end

  def shift_right?(grid)
    @pos[0] < 5 and
      grid[grid.length + 1 - @pos[1]][@pos[0] + 1] == "." and
      grid[grid.length + 0 - @pos[1]][@pos[0] + 2] == "." and
      grid[grid.length - 1 - @pos[1]][@pos[0] + 1] == "."
  end

  def shift_left!(grid)
    grid[grid.length + 1 - @pos[1]][@pos[0] + 0] = '.'
    grid[grid.length + 0 - @pos[1]][@pos[0] - 1] = '.'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 0] = '.'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 1] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0] = '.'

    grid[grid.length + 1 - @pos[1]][@pos[0] + 0 - 1] = '#' # top
    grid[grid.length + 0 - @pos[1]][@pos[0] - 1 - 1] = '#'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 0 - 1] = '#'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 1 - 1] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0 - 1] = '#' # bottom
    @pos[0] -= 1
  end

  def shift_right!(grid)
    grid[grid.length + 1 - @pos[1]][@pos[0] + 0] = '.'
    grid[grid.length + 0 - @pos[1]][@pos[0] - 1] = '.'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 0] = '.'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 1] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0] = '.'

    grid[grid.length + 1 - @pos[1]][@pos[0] + 0 + 1] = '#' # top
    grid[grid.length + 0 - @pos[1]][@pos[0] - 1 + 1] = '#'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 0 + 1] = '#'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 1 + 1] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0 + 1] = '#' # bottom
    @pos[0] += 1
  end

  def top_resting_height
    @pos[1] - 2
  end

  def shape_vertical_size
    3
  end
end

class L_plus_ratio < Shape

  def initialize(grid)
    @pos = [3, 2] # index
  end

  def place!(grid)
    @pos[1] += [grid.length - $highest_point - 3 - shape_vertical_size, 0].max
    grid[grid.length + 1 - @pos[1]][@pos[0] + 1] = '#'
    grid[grid.length - 0 - @pos[1]][@pos[0] + 1] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] - 1] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 1] = '#'
  end

  def fall?(grid)
    grid[grid.length - 2 - @pos[1]][@pos[0] - 1] == "." and
      grid[grid.length - 2 - @pos[1]][@pos[0] + 1] == "." and
      grid[grid.length - 2 - @pos[1]][@pos[0] + 0] == "."
  end

  def fall!(grid)
    grid[grid.length + 1 - @pos[1]][@pos[0] + 1] = '.'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 1] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] - 1] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 1] = '.'

    grid[grid.length + 1 - @pos[1] - 1][@pos[0] + 1] = '#' # top
    grid[grid.length + 0 - @pos[1] - 1][@pos[0] + 1] = '#'
    grid[grid.length - 1 - @pos[1] - 1][@pos[0] - 1] = '#'
    grid[grid.length - 1 - @pos[1] - 1][@pos[0] + 0] = '#'
    grid[grid.length - 1 - @pos[1] - 1][@pos[0] + 1] = '#' # bottom
    @pos[1] += 1
  end

  def shift_left?(grid)
    @pos[0] > 1 and
      grid[grid.length + 1 - @pos[1]][@pos[0] + 0] == "." and
      grid[grid.length - 1 - @pos[1]][@pos[0] - 2] == "."
  end

  def shift_right?(grid)
    @pos[0] < 5 and
      grid[grid.length + 1 - @pos[1]][@pos[0] + 2] == "." and
      grid[grid.length + 0 - @pos[1]][@pos[0] + 2] == "." and
      grid[grid.length - 1 - @pos[1]][@pos[0] + 2] == "."
  end

  def shift_left!(grid)
    grid[grid.length + 1 - @pos[1]][@pos[0] + 1] = '.'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 1] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] - 1] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 1] = '.'

    grid[grid.length + 1 - @pos[1]][@pos[0] + 0] = '#' # top
    grid[grid.length + 0 - @pos[1]][@pos[0] + 0] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] - 2] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] - 1] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0] = '#' # bottom
    @pos[0] -= 1
  end

  def shift_right!(grid)
    grid[grid.length + 1 - @pos[1]][@pos[0] + 1] = '.'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 1] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] - 1] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 1] = '.'

    grid[grid.length + 1 - @pos[1]][@pos[0] + 2] = '#' # top
    grid[grid.length + 0 - @pos[1]][@pos[0] + 2] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 1] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 2] = '#' # bottom
    @pos[0] += 1
  end

  def top_resting_height
    @pos[1] - 2
  end

  def shape_vertical_size
    3
  end
end

class VerticalBar < Shape
  def initialize(grid)
    @pos = [2, 3]
  end

  def place!(grid)
    @pos[1] += [grid.length - $highest_point - 3 - shape_vertical_size, 0].max
    4.times { |i| grid[grid.length + 2 - i - @pos[1]][@pos[0]] = '#' }
  end

  def fall?(grid)
    grid[grid.length - 2 - @pos[1]][@pos[0]] == "."
  end

  def fall!(grid)
    4.times do |i|
      grid[grid.length - @pos[1] - 1 + i][@pos[0]] = '.'
    end
    4.times do |i|
      grid[grid.length - @pos[1] - 2 + i][@pos[0]] = '#'
    end
    @pos[1] += 1
  end

  def shift_left?(grid)
    @pos[0] > 0 and
      grid[grid.length - @pos[1] + 2][@pos[0] - 1] != '#' and
      grid[grid.length - @pos[1] + 1][@pos[0] - 1] != '#' and
      grid[grid.length - @pos[1] + 0][@pos[0] - 1] != '#' and
      grid[grid.length - @pos[1] - 1][@pos[0] - 1] != '#'
  end

  def shift_right?(grid)
    @pos[0] < 6 and
      grid[grid.length - @pos[1] + 2][@pos[0] + 1] != '#' and
      grid[grid.length - @pos[1] + 1][@pos[0] + 1] != '#' and
      grid[grid.length - @pos[1] + 0][@pos[0] + 1] != '#' and
      grid[grid.length - @pos[1] - 1][@pos[0] + 1] != '#'
  end

  def shift_left!(grid)
    4.times do |i|
      grid[grid.length - @pos[1] - 1 + i][@pos[0]] = '.'
    end
    4.times do |i|
      grid[grid.length - @pos[1] - 1 + i][@pos[0] - 1] = '#'
    end
    @pos[0] -= 1
  end

  def shift_right!(grid)
    4.times do |i|
      grid[grid.length - @pos[1] - 1 + i][@pos[0]] = '.'
    end
    4.times do |i|
      grid[grid.length - @pos[1] - 1 + i][@pos[0] + 1] = '#'
    end
    @pos[0] += 1
  end

  def top_resting_height
    @pos[1] - 3
  end

  def shape_vertical_size
    4
  end
end

class BoxBox < Shape

  def initialize(grid)
    @pos = [2, 1] # index
  end

  def place!(grid)
    @pos[1] += [grid.length - $highest_point - 3 - shape_vertical_size, 0].max
    grid[grid.length + 0 - @pos[1]][@pos[0] + 0] = '#'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 1] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 1] = '#'
  end

  def fall?(grid)
    grid[grid.length - 2 - @pos[1]][@pos[0] + 0] == "." and
      grid[grid.length - 2 - @pos[1]][@pos[0] + 1] == "."
  end

  def fall!(grid)
    grid[grid.length + 0 - @pos[1]][@pos[0] + 0] = '.'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 1] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 1] = '.'

    grid[grid.length + 0 - @pos[1] - 1][@pos[0] + 0] = '#'
    grid[grid.length + 0 - @pos[1] - 1][@pos[0] + 1] = '#'
    grid[grid.length - 1 - @pos[1] - 1][@pos[0] + 0] = '#'
    grid[grid.length - 1 - @pos[1] - 1][@pos[0] + 1] = '#'

    @pos[1] += 1
  end

  def shift_left?(grid)
    @pos[0] > 0 and
      grid[grid.length - 0 - @pos[1]][@pos[0] - 1] == "." and
      grid[grid.length - 1 - @pos[1]][@pos[0] - 1] == "."
  end

  def shift_right?(grid)
    @pos[0] < 5 and
      grid[grid.length - 0 - @pos[1]][@pos[0] + 2] == "." and
      grid[grid.length - 1 - @pos[1]][@pos[0] + 2] == "."
  end

  def shift_left!(grid)
    grid[grid.length + 0 - @pos[1]][@pos[0] + 0] = '.'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 1] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 1] = '.'

    grid[grid.length + 0 - @pos[1]][@pos[0] + 0 - 1] = '#'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 1 - 1] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0 - 1] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 1 - 1] = '#'

    @pos[0] -= 1
  end

  def shift_right!(grid)
    grid[grid.length + 0 - @pos[1]][@pos[0] + 0] = '.'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 1] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0] = '.'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 1] = '.'

    grid[grid.length + 0 - @pos[1]][@pos[0] + 0 + 1] = '#'
    grid[grid.length + 0 - @pos[1]][@pos[0] + 1 + 1] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 0 + 1] = '#'
    grid[grid.length - 1 - @pos[1]][@pos[0] + 1 + 1] = '#'

    @pos[0] += 1
  end

  def top_resting_height
    @pos[1] - 1
  end

  def shape_vertical_size
    2
  end
end

def shift!(grid, moves, shape)
  move = moves[$move_index]
  $move_index = ($move_index + 1) % moves.size

  if move == ">"
    # print_grid grid
    # puts "#{move} #{$move_index - 1}"
    shape.shift_right! grid if shape.shift_right? grid
  elsif move == "<"
    # print_grid grid
    # puts "#{move} #{$move_index - 1}"
    shape.shift_left! grid if shape.shift_left? grid
  end
end

cache = {}
found_loop = 0
print_grid grid # 1_000_000_000_000
$iterations = 1_000_000_000_000
i = 0
while i < $iterations
  # 2022.times do
  shape = nil
  # dollar sign is @pos
  if shape_key == 0
    # $###
    shape = HorizontalBar.new grid
  elsif shape_key == 1
    # .#.
    # ###
    # .$.
    shape = Cross.new grid
  elsif shape_key == 2
    # ..#
    # ..#
    # #$#
    shape = L_plus_ratio.new grid
  elsif shape_key == 3
    # #
    # #
    # #
    # $
    shape = VerticalBar.new grid
  elsif shape_key == 4
    # ##
    # $#
    shape = BoxBox.new grid
  end
  # noinspection RubyNilAnalysis
  ((grid.length - $highest_point - shape.shape_vertical_size)...3).each { add_blank_row grid }
  shape.place! grid
  # gas pushes before falling
  shift!(grid, moves, shape)

  while shape.fall? grid
    shape.fall! grid
    shift!(grid, moves, shape)
  end
  rest_height = shape.top_resting_height
  $highest_point = [$highest_point, grid.length - rest_height].max

  # print_grid grid
  shape_key = (shape_key + 1) % 5
  7.times do |test|
    if grid[grid.length - test - 1].all? { |c| c == "#" }
      $reset_offset += grid.length - test - 1
      $highest_point = $highest_point - (grid.length - test - 1)
      grid = [%w[_ _ _ _ _ _ _], *grid[(grid.length - test)..]]
      clone = eval(grid.inspect) # deep copy
      key = [$highest_point, shape_key, clone, $move_index]
      if cache.key? key
        if cache[key][2] == 0
          # first time through, we don't know the repeat yet
          val = cache[key]
          cache.clear
          cache[key] = val
          cache[key] << i
          cache[key] << $reset_offset
          cache[key][2] += 1
          found_loop = 1
        elsif cache[key][2] == 1
          prev_i = cache[key][3]
          diff = i - prev_i
          copies = ($iterations - i) / diff
          puts "repeats every #{diff}, a total of #{copies} times"
          height_for_copy = $reset_offset - cache[key][4]
          $reset_offset += height_for_copy * copies
          $iterations -= i + (copies * diff)
          i = 0
          # puts diff
          cache[key][2] += 1
        end
      else
        if found_loop.zero?
          cache[key] = [$reset_offset, i, 0]
        end
      end
      break
    end
  end
  i += 1
end
puts $reset_offset + $highest_point - 1
# print_grid grid