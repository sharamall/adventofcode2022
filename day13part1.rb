file = File.open "day13in.txt"
packets = []
packets << file.take_while { |l| not l.chomp.empty? } until file.eof?
file.close
in_order = [] # indices 1-indexed
def compare(a, b)
  if a.is_a? Integer and b.is_a? Integer
    b <=> a
  elsif a.is_a? Array and b.is_a? Array
    i = 0
    while i < a.length
      return -1 if i >= b.length # b runs out of items
      res = compare(a[i], b[i])
      return res unless res.zero?
      i += 1
    end
    return 1 if i < b.length # b longer means correct order
    return 0
  elsif a.is_a? Integer
    compare([a], b)
  else
    compare(a, [b])
  end
end
packets.each_with_index do |packet, index|
  first = eval(packet[0])
  second = eval(packet[1])
  in_order << index + 1 if compare(first, second) == 1
end
puts in_order.sum