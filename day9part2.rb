file = File.open "day9in.txt"
moves = []
file.each_line do |l|
  groups = l.scan /(.) (\d+)/
  groups[0][1].to_i.times { moves << groups[0][0] }
end
pos = []
10.times { |i| pos << [0, 0] }
visited_pos = { "0 0" => "00" }
x = 0
y = 1

diff = lambda { |first, second| (first[x] - second[x]).abs + (first[y] - second[y]).abs }
diff_dim = lambda { |first, second, dim| (first[dim] - second[dim]).abs }

moves.each do |move|
  pos.first[x] += 1 if move == "R"
  pos.first[x] -= 1 if move == "L"
  pos.first[y] += 1 if move == "D"
  pos.first[y] -= 1 if move == "U"
  (1..9).each do |i|
    if (diff.call pos[i - 1], pos[i]) > 2
      pos[i][y] += pos[i - 1][y] <=> pos[i][y]
      pos[i][x] += pos[i - 1][x] <=> pos[i][x]
    elsif (diff_dim.call pos[i - 1], pos[i], x) == 2
      pos[i][x] += pos[i - 1][x] <=> pos[i][x]
    elsif (diff_dim.call pos[i - 1], pos[i], y) == 2
      pos[i][y] += pos[i - 1][y] <=> pos[i][y]
    else
      break
    end
  end
  visited_pos["#{pos[9][x]} #{pos[9][y]}"] = "my little pogchamp"
end
puts visited_pos.size