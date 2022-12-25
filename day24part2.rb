class Main
  @file
  @cache
  @max_x
  @max_y
  @min_time
  @min_time_key
  @moves_to_consider
  @blissard_cache

  attr_reader :cache, :min_time, :max_x, :max_y

  def initialize
    @max_x = 0
    @max_y = 0
    @cache = {}
    @min_time = 1e10
    @min_time_key = nil
    @moves_to_consider = []
    @blissard_cache = {}
  end

  def pos_to_key(pos)
    raise "oop" if pos.nil?
    "#{pos[:x]}_#{pos[:y]}"
  end

  def to_cache_entry(pos, time)
    key = "#{pos_to_key(pos)}: #{time}"
    {
      key: key,
      value: {
        time: time,
        pos: pos
      }
    }
  end

  def load_from_file
    blissards = []
    row = 0
    @file = File.open "day24in.txt"
    @file.each_line do |l|
      blissards << []
      l.chomp.each_char { |c| blissards[row] << [c] }
      row += 1
    end
    @max_y = row - 1
    @file.close
    blissards
  end

  def arr_to_blissard_hash(arr)
    blissards = {}
    arr.length.times do |row|
      if row == 0
        @max_x = arr[row].length
        next
      end
      next if row == @max_y
      arr[row].length.times do |col|
        c_arr = arr[row][col]
        next if c_arr[0] == "#" or c_arr[0] == "."
        key = "#{col}_#{row}"
        blissards[key] = [] unless blissards.key? key
        c_arr.each { |c| blissards[key] << c }
      end
    end
    blissards
  end

  def run(blissards, time)
    @moves_to_consider << [{ x: 1, y: 0 }, time]
    @blissard_cache[time] = blissards
    find_best until @moves_to_consider.empty?
    @blissard_cache[@min_time]
  end

  def clear_run
    @blissard_cache.clear
    @moves_to_consider.clear
    @cache.clear
    @min_time = 1e10
  end

  def run_step(blissards)
    new_blissards = {}
    blissards.each do |k, list|
      raw = k.split "_"
      pos = { x: raw[0].to_i, y: raw[1].to_i }
      list.each do |b|
        new_pos = nil
        if b == ">"
          if pos[:x] == @max_x - 2
            # reset to beginning
            new_pos = { x: 1, y: pos[:y] }
          else
            new_pos = { x: pos[:x] + 1, y: pos[:y] }
          end
        elsif b == "<"
          if pos[:x] == 1
            # reset to beginning
            new_pos = { x: @max_x - 2, y: pos[:y] }
          else
            new_pos = { x: pos[:x] - 1, y: pos[:y] }
          end
        elsif b == "v"
          if pos[:y] == @max_y - 1
            # reset to beginning
            new_pos = { x: pos[:x], y: 1 }
          else
            new_pos = { x: pos[:x], y: pos[:y] + 1 }
          end
        elsif b == "^"
          if pos[:y] == 1
            # reset to beginning
            new_pos = { x: pos[:x], y: @max_y - 1 }
          else
            new_pos = { x: pos[:x], y: pos[:y] - 1 }
          end
        end
        new_key = pos_to_key(new_pos)
        new_blissards[new_key] = [] unless new_blissards.key? new_key
        new_blissards[new_key] << b
        new_blissards[new_key].sort!
      end
    end
    blissards.clear
    new_blissards.each { |k, v| blissards[k] = v }
  end

  def print_arena(blissards, pos)
    printed_e = false
    (0..@max_y).each do |y|
      (0...@max_x).each do |x|
        key = pos_to_key({ x: x, y: y })
        if pos[:x] == x and pos[:y] == y
          raise "invalid position" if pos[:y] == @max_y and pos[:x] != @max_x - 2
          raise "invalid position" if blissards.key? key
          print "E"
          printed_e = true
          next
        end
        if x == 0 or x == @max_x - 1 or y == 0 or y == @max_y
          print "#"
        else
          print blissards[key][0] if blissards.key? key and blissards[key].length == 1
          print blissards[key].length if blissards.key? key and blissards[key].length > 1
          print "." unless blissards.key? key
        end
      end
      puts ""
    end
    puts ""
    raise "invalid position" unless printed_e
  end

  def find_best
    pos, time = *@moves_to_consider[0]
    blissards = @blissard_cache[time]
    @moves_to_consider = @moves_to_consider[1..]
    return if time > @min_time
    entry = to_cache_entry(pos, time)
    # don't investigate the same state if we've seen it with less time, or if we know it's invalid aka -1
    if @cache.key? entry[:key] and (time >= @cache[entry[:key]][:time] or @cache[entry[:key]][:time] == -1)
      return
    elsif pos[:x] == @max_x - 2 and pos[:y] == @max_y
      # if
      puts "exit in #{time} steps, moves left #{@moves_to_consider.length}"
      @min_time = time
      @min_time_key = entry[:key]
      @cache[entry[:key]] = entry[:value]
    else
      # print_arena(blissards, pos)
      @cache[entry[:key]] = entry[:value]
      moves = [{ x: pos[:x], y: pos[:y] }] # stay in place
      if pos[:y] > 0
        moves << { x: pos[:x] - 1, y: pos[:y] } unless pos[:x] <= 1
        moves << { x: pos[:x] + 1, y: pos[:y] } unless pos[:x] == @max_x - 2
      end
      if pos[:x] > 0
        moves << { x: pos[:x], y: pos[:y] - 1 } unless pos[:y] <= 1
        moves << { x: pos[:x], y: pos[:y] + 1 } if (pos[:y] == @max_y - 1 and pos[:x] == @max_x - 2) or (pos[:y] < @max_y - 1)
      end
      moves.sort_by do |m|
        x_diff = @max_x - m[:x]
        y_diff = @max_y - m[:y]
        x_diff + y_diff
      end
      moves.reverse!

      unless @blissard_cache.key? time + 1
        @blissard_cache[time + 1] = eval(blissards.inspect)
        run_step(@blissard_cache[time + 1])
      end
      # print_arena(blissards, pos)
      any_moves_found = false
      moves.each do |move|
        key = pos_to_key(move)
        if @blissard_cache[time + 1].key? key # occupied
          @cache[entry[:key]] = { time: -1 } # invalid
          next
        end
        # print_arena(new_blissards, move)
        any_moves_found = true
        @moves_to_consider << [move, time + 1]
      end
    end
  end
end

m = Main.new
blissard_arr = m.load_from_file
final_blissard_hash = m.run m.arr_to_blissard_hash(blissard_arr), 0
total = m.min_time
puts "time to first exit: #{m.min_time}"
m.clear_run

final_blissard_arr = []
(0..m.max_y).each do |row|
  final_blissard_arr << []
  (0...m.max_x).each do |col|
    if row == 0 || row == m.max_y || col == 0 || col == m.max_x - 1
      final_blissard_arr[row] << "#"
    else
      final_blissard_arr[row] << final_blissard_hash["#{col}_#{row}"] if final_blissard_hash.key? "#{col}_#{row}"
      final_blissard_arr[row] << "." unless final_blissard_hash.key? "#{col}_#{row}"
    end
  end
end

reversed_arr = final_blissard_arr.transpose.reverse.transpose.reverse
reversed_arr.each do |row|
  col = 0
  row.each do |item|
    unless item == "." or item == "#"
      row[col] = [col] unless item.is_a? Array
      new_col = []
      row[col].each do |c|
        if c == "^"
          new_col << "v"
        elsif c == "v"
          new_col << "^"
        elsif c == "<"
          new_col << ">"
        elsif c == ">"
          new_col << "<"
        end
        new_col.sort!
        row[col] = new_col
      end
    end
    col += 1
  end
end
m.run m.arr_to_blissard_hash(reversed_arr), 0
m.min_time.times { m.run_step(final_blissard_hash) }
total += m.min_time
puts "time to snacc: #{m.min_time}"
m.clear_run

m.run final_blissard_hash, 0
total += m.min_time
puts "time to finish: #{m.min_time}, total: #{total}"