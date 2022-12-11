file = File.open "day11in.txt"
i = 0

class MonkE
  @id
  @items
  @true_throw
  @false_throw
  @operation
  @test
  @count
  attr_accessor :id, :items, :true_throw, :false_throw, :operation, :test, :count

  def initialize
    super
    @items = []
    @true_throw = nil
    @false_throw = nil
    @operation = nil
    @test = nil
    @count = 0
  end
end

monks = []
cur_monk = nil
file.each_line do |l|
  if i == 0
    monks << cur_monk unless cur_monk.nil?
    cur_monk = MonkE.new
    cur_monk.id = l.scan(/Monkey (\d+):/)[0][0].to_i
  elsif i == 1
    cur_monk.items = l.gsub(",", "").gsub("  Starting items: ", "").chomp.split.map { |item| item.to_i }
  elsif i == 2
    test_str = l.gsub(",", "").gsub("  Operation: new = ", "").chomp
    res = test_str.scan /old (\*)/
    if res.empty?
      res = test_str.scan /old \+ (\d+)/ if res.empty?
      cur_monk.operation = ->(val) { val + res[0][0].to_i } unless res.empty?
      cur_monk.operation = ->(val) { val + val } if res.empty?
    else
      res = test_str.scan /old \* (\d+)/
      cur_monk.operation = ->(val) { val * res[0][0].to_i } unless res.empty?
      cur_monk.operation = ->(val) { val * val } if res.empty?
    end
  elsif i == 3
    cur_monk.test = l.scan(/\s*Test: divisible by (\d+)/)[0][0].to_i
  elsif i == 4
    cur_monk.true_throw = l.scan(/\s*If true: throw to monkey (\d+)/)[0][0].to_i
  elsif i == 5
    cur_monk.false_throw = l.scan(/\s*If false: throw to monkey (\d+)/)[0][0].to_i
  end
  i += 1
  i %= 7
end
monks << cur_monk
file.close
monkE_map = {}
monks.each { |m| monkE_map[m.id] = m }
i = 0

20.times do
  monks.each do |monk_ass|
    monk_ass.items.each do |item|
      worry = monk_ass.operation.call(item)
      worry /= 3
      if (worry % monk_ass.test) == 0
        monkE_map[monk_ass.true_throw].items << worry
      else
        monkE_map[monk_ass.false_throw].items << worry
      end
      monk_ass.count += 1
    end
    monk_ass.items = []
  end
end
res = monks.collect { |m| m.count }.sort.reverse
puts res[0] * res[1]