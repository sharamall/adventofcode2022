file = File.open "day21in.txt"
root = nil
$monk_deez_nuts = {}

class MonkE
  @key
  @num
  @left
  @right
  @operator
  attr_reader :key
  attr_accessor :num, :left, :right, :operator

  def initialize(key)
    @key = key
    @left = nil
  end

  def num?
    @left.nil?
  end
end

file.each_line do |l|
  result = l.scan /(\w+): (.*)/
  monk_ass = MonkE.new(result[0][0])
  root = monk_ass if result[0][0] == "root"
  res2 = result[0][1].scan /(\w+) (.) (\w+)/
  if res2.empty?
    # number
    monk_ass.num = result[0][1].to_i
  else
    # operator
    monk_ass.left = res2[0][0]
    monk_ass.operator = res2[0][1]
    monk_ass.right = res2[0][2]
  end
  $monk_deez_nuts[monk_ass.key] = monk_ass
end
$monk_deez_nuts.each do |_, monk|
  unless monk.num?
    monk.left = $monk_deez_nuts[monk.left]
    monk.right = $monk_deez_nuts[monk.right]
  end
end

def solve(monkE)
  return monkE.num if monkE.num?
  left = solve(monkE.left)
  right = solve(monkE.right)
  return left + right if monkE.operator == "+"
  return left - right if monkE.operator == "-"
  return left * right if monkE.operator == "*"
  return left / right if monkE.operator == "/"
end

puts solve(root)