file = File.open "day7in.txt"
filesystem = { "".to_sym => { folders: { "/": { files: [], folders: {} } } } }
cur_dir = []

file.each_line do |l|
  if l[0] == "$"
    if l[2] == "c" and l[3] == "d"
      dir = l[5...l.length].chomp
      cur_dir = cur_dir[0...(cur_dir.length - 1)] if dir == ".."
      cur_dir << dir unless dir == ".."
    end
  elsif l[0] == "d" and l[1] == "i" and l[2] == "r"
    subdir = l[4..l.length].chomp
    folders_hash = filesystem["".to_sym][:folders]
    cur_dir.each { |folder| folders_hash = folders_hash[folder.to_sym][:folders] }
    folders_hash[subdir.to_sym] = { files: [], folders: {} } unless folders_hash.any? { |hash| hash.include? subdir }
  else
    results = l.scan /(\d+) (.+)/
    folders_hash = filesystem["".to_sym]
    cur_dir.each { |folder| folders_hash = folders_hash[:folders][folder.to_sym] }
    folders_hash[:files] << { size: results[0][0].to_i, name: results[0][1] } unless folders_hash[:files].any? { |hash| hash[:name] == results[0][1] }
  end
end
file.close
sizes = []

def dir_size(dir, sizes)
  size = 0
  dir[:files].each { |f| size += f[:size] }
  dir[:folders].each { |k, v| size += dir_size v, sizes }
  if size <= 100000
    sizes << size
  end
  size
end

filesystem["".to_sym][:folders].each { |k, v| dir_size v, sizes }
puts sizes.sum