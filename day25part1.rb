def to_dec(str)
  place = 0
  val = 0
  str.reverse.each_char do |c|
    cur = c.to_i
    cur = -1 if c == "-"
    cur = -2 if c == "="
    val += (cur * (5 ** place))
    place += 1
  end
  val
end

def to_snafu(i)
  str = ""
  place = 0
  carry = 0
  while i > 0 or carry > 0
    val = 5 ** (place)
    num = i % (5 ** (place + 1))
    num /= val
    num_without_carry = num
    num += carry
    if num <= 2
      str = "#{num}#{str}"
      carry = 0
    else
      carry = 1
      str = "=#{str}" if num == 3
      str = "-#{str}" if num == 4
      str = "0#{str}" if num == 5
    end
    i -= (num_without_carry * val)
    place += 1
  end
  str
end

val = File.open("day25in.txt").collect { |l| to_dec l.chomp }.sum()
puts to_snafu val
