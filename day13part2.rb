file = File.open "day13in.txt"
packets = []
until file.eof?
  packets << file.take_while { |l| not l.chomp.empty? }
end
file.close
def compare(a, b)
  if a.is_a? Integer and b.is_a? Integer
    return 0 if a == b
    return 1 if a < b
    return -1 if a > b
  elsif a.is_a? Array and b.is_a? Array
    i = 0
    while i < a.length
      if i >= b.length
        return -1 # b runs out of items
      end
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

class Packet
  @arr
  attr_reader :arr

  def initialize(arr)
    @arr = arr
  end

  def <=>(other)
    compare(self.arr, other.arr)
  end
end

clean_packets = [Packet.new([[2]]), Packet.new([[6]])]
packets.each_with_index do |packet|
  first = Packet.new(eval(packet[0]))
  second = Packet.new(eval(packet[1]))
  clean_packets << first
  clean_packets << second
end
i = 1
clean_packets.sort.reverse.collect { |p| p.arr }.each_with_index do |elem, index|
  if elem == [[2]]
    i = index + 1
  elsif elem == [[6]]
    puts i * (index + 1)
    break
  end
end