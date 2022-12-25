class Main
  @file
  @cache
  @max_x
  @max_y
  @min_time
  @moves_to_consider
  @blissard_cache
  attr_reader :cache, :min_time

  def initialize
    @max_x = 0
    @max_y = 0
    @cache = {}
    @min_time = 1e10
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

  def run
    pos = { x: 1, y: 0 }
    blissards = {}
    row = 0
    @file = File.open "day24in.txt"

    @file.each_line do |l|
      if row == 0
        @max_x = l.length - 1
        row += 1
        next
      end
      if l.start_with? "##"
        @max_y = row
        row += 1
        next
      end
      col = 0
      l.chomp.each_char do |c|
        col += 1
        next if c == "#" or c == "."
        key = "#{col - 1}_#{row}"
        blissards[key] = [] unless blissards.key? key
        blissards[key] << c
      end
      row += 1
    end

    @file.close
    @moves_to_consider << [pos, 0]
    @blissard_cache[0] = blissards
    find_best until @moves_to_consider.empty?
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
beginning = Time.now
m.run
puts "min time: #{m.min_time} in #{Time.now - beginning}"
# puts m.cache