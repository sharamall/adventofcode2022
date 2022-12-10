class Tester

  def run

    @cycle = 1
    @reg_x = 1
    @signal = 0
    @checked = {}
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
      unless @checked[@cycle].nil?
        puts "sus"
      end
      if @cycle == 20 or ((@cycle - 20) % 40 == 0)
        @checked[@cycle] = @cycle
        @signal += @reg_x * @cycle
      end
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
    puts @signal
  end
end

Tester.new.run