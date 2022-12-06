file = File.open "day6in.txt"
file.each_line do |l|
  cur = 0
  arr = []

  l.each_char do |ch|
    arr << ch
    if cur > 12
      match = false
      (0..(arr.length - 1)).each do |i|
        ((i + 1)..(arr.length - 1)).each do |j|
          match = true if arr[i] == arr[j]
        end
      end
      unless match
        puts cur + 1
        break
      end
      arr = arr[1..(arr.length - 1)]
    end
    cur += 1
  end
end
file.close