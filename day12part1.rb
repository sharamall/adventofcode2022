file = File.open "day12in.txt"
grid = []
cost = []
visited = []
unvisited = {}
start = nil
dest = nil
row = 0
col = 0

file.each_line do |l|
  grid << []
  cost << []
  l.chomp.each_char do |c|
    if c == "S"
      start = [row, col]
      grid[row] << 0
      cost[row] << 0
      unvisited[row.to_s + "_" + col.to_s] = 0
    elsif c == "E"
      dest = [row, col]
      grid[row] << 25
      cost[row] << 1e15
    else
      grid[row] << c.ord - 97
      cost[row] << 1e15
    end
    col += 1
  end
  row += 1
  col = 0
end

def min_hash(hash)
  min_key = nil
  min_val = 1e16
  hash.each do |k, v|
    if min_val > v
      min_key = k
      min_val = v
    end
  end
  min_key
end

def neighbours(grid, row, col)
  res = [nil, nil, nil, nil] # N, W, S, E
  if col > 0
    unless grid[row][col - 1] - 1 > grid[row][col]
      res[1] = 1
    end
  end

  if col < grid[0].length - 1 # s
    unless grid[row][col + 1] - 1 > grid[row][col]
      res[3] = 1
    end
  end

  if row > 0
    unless grid[row - 1][col] - 1 > grid[row][col]
      res[0] = 1
    end
  end

  if row < grid.length - 1 # e
    unless grid[row + 1][col] - 1 > grid[row][col]
      res[2] = 1
    end
  end
  res
end

row = start[0]
col = start[1]

until dest == [row, col]
  neigh = neighbours grid, row, col # N, W, S, E
  neigh.each_with_index do |elem, i|
    unless elem.nil?
      dest_row = row
      dest_col = col
      dest_row = row - 1 if i == 0
      dest_col = col - 1 if i == 1
      dest_row = row + 1 if i == 2
      dest_col = col + 1 if i == 3

      unless visited.include? [dest_row, dest_col]
        unvisited[dest_row.to_s + "_" + dest_col.to_s] = 1e15 if unvisited[dest_row.to_s + "_" + dest_col.to_s].nil?
        previous_cost = unvisited[dest_row.to_s + "_" + dest_col.to_s]
        current_cost = unvisited[row.to_s + "_" + col.to_s]
        unvisited[dest_row.to_s + "_" + dest_col.to_s] = current_cost + 1 if current_cost < previous_cost
        if dest == [dest_row, dest_col]
          puts "path to dest with cost #{unvisited[dest_row.to_s + "_" + dest_col.to_s]}"
        end
      end
    end
  end
  visited << [row, col]
  unvisited.reject! do |k, v|
    if k == (row.to_s + "_" + col.to_s)
      cost[row][col] = v
      true
    else
      false
    end
  end

  next_ = min_hash(unvisited)
  res = next_.split "_"

  new_row = res[0].to_i
  new_col = res[1].to_i
  if dest == [new_row, new_col]
    cost[dest[0]][dest[1]] = unvisited[new_row.to_s + "_" + new_col.to_s]
  end
  row = new_row
  col = new_col
end
puts cost[dest[0]][dest[1]]