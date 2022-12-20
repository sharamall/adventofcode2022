file = File.open "day20in.txt"

class Item
  @prev
  @next
  @val
  attr_reader :val
  attr_accessor :prev, :next

  def initialize(val)
    @val = val
    @prev = nil
    @next = nil
  end
end

input = Item.new(-1)
moves = []
prev = input
unique = {}
i = 0
file.each_line do |l|
  moves << (l.to_i * 811589153)
  next_ = Item.new(l.to_i * 811589153)

  unique[i] = next_
  i += 1
  prev.next = next_
  next_.prev = prev
  prev = next_
end
file.close
input.next.prev = prev
prev.next = input.next
input = input.next

10.times do
  moves.each_with_index do |val, index|
    unless val.zero?
      linked = unique[index]
      (val.abs % (moves.length - 1)).times do
        if val < 0
          linked.prev.next = linked.next
          linked.next.prev = linked.prev
          linked.prev = linked.prev.prev
          linked.next = linked.prev.next
          linked.prev.next = linked
          linked.next.prev = linked
        elsif val > 0
          linked.prev.next = linked.next
          linked.next.prev = linked.prev
          linked.next = linked.next.next
          linked.prev = linked.next.prev
          linked.prev.next = linked
          linked.next.prev = linked
        end
      end
    end
  end
end

input = input.next until input.val.zero?
sum = 0
1000.times { input = input.next }
sum += input.val
1000.times { input = input.next }
sum += input.val
1000.times { input = input.next }
sum += input.val
puts sum