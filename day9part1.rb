file = File.open "day9in.txt"
moves = []
file.each_line do |l|
  groups = l.scan /(.) (\d+)/
  groups[0][1].to_i.times { moves << groups[0][0] }
end
pos = [[0, 0], [0, 0]]
visited_pos = { "0 0" => "00" }

moves.each  do |move|
  if move == "R"
    # x's are same, so we're not vertically aligned
    on_same_column = pos[0][0] == pos[1][0]
    unless on_same_column
      if pos[0][0] > pos[1][0] # yes
        #  0 ->
        pos[1][0] += 1 # yes
        pos[1][1] += 1 if (pos[0][1] > pos[1][1]) # yes
        pos[1][1] -= 1 if (pos[0][1] < pos[1][1]) # yes
        visited_pos[pos[1][0].to_s + " " + pos[1][1].to_s] = "lol nice"
      end
    end
    pos[0][0] += 1 # yes
  elsif move == "L"
    # x's are same, so we're not vertically aligned
    on_same_column = pos[0][0] == pos[1][0] # yes
    unless on_same_column
      if pos[0][0] < pos[1][0] # yes
        # <- 0
        #      1
        pos[1][0] -= 1
        pos[1][1] += 1 if (pos[0][1] > pos[1][1]) # yes
        pos[1][1] -= 1 if (pos[0][1] < pos[1][1]) # yes
        visited_pos[pos[1][0].to_s + " " + pos[1][1].to_s] = "lol nice"
      end
    end
    pos[0][0] -= 1 # yes
  elsif move == "U"
    # y's are same, so we're not horizontally aligned
    on_same_row = pos[0][1] == pos[1][1]
    unless on_same_row
      if pos[0][1] > pos[1][1] # yes
        # 0
        # ^
        # 1
        pos[1][1] += 1
        pos[1][0] += 1 if (pos[0][0] > pos[1][0])
        pos[1][0] -= 1 if (pos[0][0] < pos[1][0])
        visited_pos[pos[1][0].to_s + " " + pos[1][1].to_s] = "lol nice"
      end
    end
    pos[0][1] += 1 # yes
  elsif move == "D"
    # y's are same, so we're not horizontally aligned
    on_same_row = pos[0][1] == pos[1][1]
    unless on_same_row
      if pos[0][1] < pos[1][1] # yes
        # 1
        # ^
        # 0
        pos[1][1] -= 1
        pos[1][0] += 1 if (pos[0][0] > pos[1][0])
        pos[1][0] -= 1 if (pos[0][0] < pos[1][0])
        visited_pos[pos[1][0].to_s + " " + pos[1][1].to_s] = "lol nice"
      end
    end
    pos[0][1] -= 1 # yes
  end
end
puts visited_pos.size