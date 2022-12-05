file = File.open "day5in.txt"
max_column = 0
in_columns = []
moves = []
line = 0
skip = false
first_input = true
file.each_line do |l|
  char = 0
  column = 0
  reading_char = false
  if first_input
    l.each_char do |c|
      if l == "\n" || skip
        first_input = false
        columns = l.chomp.split
        if max_column == 0
          max_column = columns[columns.length - 1].to_i
          in_columns[0] = in_columns[0][0..(max_column - 1)]
        end
      elsif first_input
        if c == " "
          if char % 4 == 0
            in_columns << [] if in_columns[column].nil?
            column += 1
          end
        elsif c == "["
          reading_char = true
        elsif c == "1"
          skip = true
        elsif reading_char
          in_columns << [] if in_columns[column].nil?
          in_columns[column] << c
          reading_char = false
          column += 1
        end
      end
      char += 1
    end
  elsif l != "\n"
    m = l.scan /move (\d+) from (\d+) to (\d+)/
    m = m[0].collect { |item| item.to_i }
    moves << m
  end
  skip = false
  line += 1
end
moves.each do |move|
  num_to_move = move[0]
  from = move[1]
  to = move[2]
  to_move = in_columns[from - 1][0..(num_to_move - 1)]
  in_columns[from - 1] = in_columns[from - 1][(num_to_move)..(in_columns[from - 1].length)]
  in_columns[to - 1] = to_move + in_columns[to - 1]
end
file.close
in_columns.each { |row| print row[0] }
STDOUT.flush