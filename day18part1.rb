file = File.open "day18in.txt"
drops = {}
def to_coord_str(x, y, z)
  "#{x}_#{y}_#{z}"
end

file.each_line do |l|
  raw_coords = l.split ","
  coords = raw_coords.collect { |c| c.to_i }
  drops[to_coord_str(coords[0], coords[1], coords[2])] = coords
end
file.close
res = drops.sum do |_, v|
  coords = v
  x = coords[0]
  y = coords[1]
  z = coords[2]
  surfaces = 0
  surfaces += 1 unless drops.key? to_coord_str(x + 1, y + 0, z + 0) # unless 😳
  surfaces += 1 unless drops.key? to_coord_str(x - 1, y + 0, z + 0)
  surfaces += 1 unless drops.key? to_coord_str(x + 0, y + 1, z + 0)
  surfaces += 1 unless drops.key? to_coord_str(x + 0, y - 1, z + 0)
  surfaces += 1 unless drops.key? to_coord_str(x + 0, y + 0, z + 1)
  surfaces += 1 unless drops.key? to_coord_str(x + 0, y + 0, z - 1)

  surfaces
end
puts res