file = File.open "day23in.txt"
elves = {}
row = 0
col = 0
min_x = 0
min_y = 0
max_x = -1e10
max_y = -1e10
moves = [:north, :south, :west, :east]

def to_key(r, c)
  "#{r}_#{c}"
end

def print_elves(elves, x_m, x__m, y_m, y__m)
  (y_m..y__m).each do |y|
    (x_m..x__m).each do |x|
      key = to_key(y, x,)
      print "#" if elves.key? key
      print "." unless elves.key? key
    end
    puts ""
  end
  puts "\nveibae\n"
end

file.each_line do |l|
  l.chomp.each_char do |c|
    if c == "#"
      elves[to_key(row, col)] = { x: col, y: row }
    end
    col += 1
  end
  row += 1
  max_x = col
  col = 0
end
max_y = row

round = 0
while true
  round += 1
  to_move = {}
  elves.each do |k, e|
    proposals = []
    col = e[:x]
    row = e[:y]
    moves.each do |m|
      if m == :north or m == :south
        d = 1
        d = -1 if m == :north
        unless elves.key? to_key(row + d, col - 1) or elves.key? to_key(row + d, col) or elves.key? to_key(row + d, col + 1)
          proposals << { x: col, y: row + d, from: e, collision: false }
        end
      elsif m == :west or m == :east
        d = 1
        d = -1 if m == :west
        unless elves.key? to_key(row - 1, col + d) or elves.key? to_key(row, col + d) or elves.key? to_key(row + 1, col + d)
          proposals << { x: col + d, y: row, from: e, collision: false }
        end
      end
    end
    next if proposals.empty? or proposals.length == 4
    proposal = proposals[0]
    key = to_key(proposal[:y], proposal[:x])
    if to_move.key? key
      proposal[:collision] = true
      to_move[key][:collision] = true
    else
      to_move[key] = proposal unless proposals.length == moves.length
    end
  end
  to_move.each do |k, v|
    if v[:collision]
      to_move.delete k
    else
      prev_key = to_key(v[:from][:y], v[:from][:x])
      new_key = to_key(v[:y], v[:x])
      elves.delete prev_key
      elves[new_key] = v
      max_x = v[:x] if v[:x] > max_x
      min_x = v[:x] if v[:x] < min_x
      max_y = v[:y] if v[:y] > max_y
      min_y = v[:y] if v[:y] < min_y
    end
  end
  if to_move.empty?
    print_elves elves, min_x, max_x, min_y, max_y
    puts round
    exit!(1)
  end
  moves.push moves.shift
end