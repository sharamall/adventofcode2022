class Tester

  def run

    @cycle = 1
    @reg_x = 1
    @checked = {}
    @line = 0
    @col = 0
    @crt = [[]]
    file = File.open "day10in.txt"

    commands = []
    file.each_line do |l|
      result = l.scan(/(\w+)\s*(-?)(\d*)/)[0]
      if result[1] == "-"
        result[2] = -(result[2].to_i)
      end
      commands << [result[0], result[2]]
    end

    def check_cycle
      if (@col - @reg_x).abs < 2
        @crt[@line] <<  '#'
      else
        @crt[@line] << '.'
      end
      @col += 1
      @line += 1 if @col == 40
      @crt << [] if @col == 40
      @col = 0 if @col == 40
    end

    commands.each do |c|
      if c[0] == "noop"
        check_cycle
        @cycle += 1
      elsif c[0] == "addx"
        check_cycle
        @cycle += 1
        check_cycle
        @cycle += 1
        @reg_x += c[1].to_i
      else
        puts "bad"
      end
    end
    @crt.each { |v| puts v.inspect.gsub("[", "") .gsub(" ", "").gsub("\"", "").sub(",", "").gsub("]", "")}
  end
end

Tester.new.run