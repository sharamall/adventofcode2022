file = File.open "day4in.txt"
full_overlaps = 0
file.each_line do |l|
  pairs = l.chomp.split ","
  p1 = pairs[0].split "-"
  p2 = pairs[1].split "-"
  if p1[0].to_i <= p2[0].to_i and p1[1].to_i >= p2[1].to_i
    full_overlaps += 1
    puts "overlap #{pairs}"
  elsif p2[0].to_i <= p1[0].to_i and p2[1].to_i >= p1[1].to_i
    full_overlaps += 1
    puts "overlap #{pairs}"
  else
    puts "no overlap #{pairs}"
  end
end
file.close
puts full_overlaps