require 'etc'
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
$fixed = {}

def solve(monkE)
  if monkE.key == "humn"
    return ["x", false]
  end
  if monkE.num?
    return [monkE.num, true]
  end
  if $fixed.key? monkE.left.key
    left = $fixed[monkE.left.key]
  else
    left = solve(monkE.left)
    $fixed[monkE.left.key] = left if left[1]
  end
  if $fixed.key? monkE.right.key
    right = $fixed[monkE.right.key]
  else
    right = solve(monkE.right)
    $fixed[monkE.right.key] = right if right[1]
  end
  is_fixed = left[1] && right[1]
  return [eval("#{left[0]} #{monkE.operator} #{right[0]}"), true] if is_fixed
  return [[left[0], monkE.operator, right[0]], false]
end

def reduce(to_solve, other_side)
  op = to_solve[1]
  if to_solve[0].is_a? Integer
    # left is fixnum
    if op == "+"
      other_side -= to_solve[0]
      to_solve = to_solve[2]
    elsif op == "-"
      other_side = to_solve[0] - other_side
      to_solve = to_solve[2]
    elsif op == "*"
      other_side /= to_solve[0]
      to_solve = to_solve[2]
    elsif op == "/"
      other_side = to_solve[0] / other_side
      to_solve = to_solve[2]
    end
  else
    # right is fixnum
    if op == "+"
      other_side -= to_solve[2]
      to_solve = to_solve[0]
    elsif op == "-"
      other_side += to_solve[2]
      to_solve = to_solve[0]
    elsif op == "*"
      other_side /= to_solve[2]
      to_solve = to_solve[0]
    elsif op == "/"
      other_side *= to_solve[2]
      to_solve = to_solve[0]
    end
  end
  [to_solve, other_side]
end

left = solve(root.left)
right = solve(root.right)
to_solve = left[0] unless left[1]
to_solve = right[0] unless right[1]
other_side = left[0] if left[1]
other_side = right[0] if right[1]

until to_solve[0] == "x" or to_solve[1] == "x"
  (to_solve, other_side) = reduce(to_solve, other_side)
end
(to_solve, other_side) = reduce([[], to_solve[1], to_solve[2]], other_side) if to_solve[0] == "x"
(to_solve, other_side) = reduce([to_solve[0], to_solve[1], []], other_side) if to_solve[2] == "x"
puts other_side
