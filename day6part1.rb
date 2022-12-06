file = File.open "day6in.txt"
file.each_line do |l|
  cur = 0
  a = ""
  b = ""
  c = ""
  d = ""

  l.each_char do |ch|
    a = b
    b = c
    c = d
    d = ch
    if cur > 2
      if a != b and a != c and a != d and b != c and b != d and c != d
        puts cur + 1
        break
      end
    end
    cur += 1
  end
end
file.close