file = File.open "day18in.txt"
$drops = {}
$max_x = -1e10
$min_x = 1e10
$max_y = -1e10
$min_y = 1e10
$max_z = -1e10
$min_z = 1e10

def to_coord_str(x, y, z)
  "#{x}_#{y}_#{z}"
end

file.each_line do |l|
  raw_coords = l.split ","
  coords = raw_coords.collect { |c| c.to_i }
  $drops[to_coord_str(coords[0], coords[1], coords[2])] = ["input", coords]
  $max_x = coords[0] unless $max_x > coords[0]
  $min_x = coords[0] unless $min_x < coords[0]
  $max_y = coords[1] unless $max_y > coords[1]
  $min_y = coords[1] unless $min_y < coords[1]
  $max_z = coords[2] unless $max_z > coords[2]
  $min_z = coords[2] unless $min_z < coords[2]
end
file.close

def fill(x, y, z)
  coords_to_process = [[x, y, z]]
  until coords_to_process.empty?
    x, y, z = *coords_to_process.pop
    next if x < $min_x or x > $max_x or y < $min_y or y > $max_y or z < $min_z or z > $max_z
    coord_str = to_coord_str x, y, z
    unless $drops.key?(coord_str)
      $drops[coord_str] = ["outside"]
      coords_to_process << [x - 1, y, z]
      coords_to_process << [x + 1, y, z]
      coords_to_process << [x, y - 1, z]
      coords_to_process << [x, y + 1, z]
      coords_to_process << [x, y, z - 1]
      coords_to_process << [x, y, z + 1]
    end
  end

end

def num_open_surfaces(x, y, z)
  surfaces = 0
  surfaces += 1 if $drops[to_coord_str(x + 1, y + 0, z + 0)]&.send(:[], 0) == "outside"
  surfaces += 1 if $drops[to_coord_str(x - 1, y + 0, z + 0)]&.send(:[], 0) == "outside"
  surfaces += 1 if $drops[to_coord_str(x + 0, y + 1, z + 0)]&.send(:[], 0) == "outside"
  surfaces += 1 if $drops[to_coord_str(x + 0, y - 1, z + 0)]&.send(:[], 0) == "outside"
  surfaces += 1 if $drops[to_coord_str(x + 0, y + 0, z + 1)]&.send(:[], 0) == "outside"
  surfaces += 1 if $drops[to_coord_str(x + 0, y + 0, z - 1)]&.send(:[], 0) == "outside"

  surfaces
end

$min_x -= 1
$max_x += 1
$min_y -= 1
$max_y += 1
$min_z -= 1
$max_z += 1
fill($min_x, $min_y, $min_z)

res = $drops.sum do |k, v|
  if v[0] == "input"
    coords = v[1]
    x = coords[0]
    y = coords[1]
    z = coords[2]
    num_open_surfaces(x, y, z)
  else
    0
  end
end
puts res