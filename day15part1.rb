file = File.open "day15in.txt"

class SensorBeacon
  @sx
  @sy
  @bx
  @by
  attr_reader :sx, :sy, :bx, :by

  def initialize(sx, sy, bx, by)
    @sx, @sy = sx, sy
    @bx, @by = bx, by
  end

  def dist
    (@sx - @bx).abs + (@sy - @by).abs
  end

  def dist_to(x, y)
    (@sx - x).abs + (@sy - y).abs
  end
end

class Range
  def overlaps?(other)
    # monkey patch
    cover?(other.first) || other.cover?(first)
  end

  def <=>(other)
    self.begin <=> other.begin
  end

  def length
    (self.begin - self.end).abs + 1
  end
end

def insert_range(ranges, range)
  i = 0
  inserted = false
  until i >= ranges.length or inserted
    if range.overlaps? ranges[i]
      if range.cover? ranges[i] # fully contains the other range
        ranges[i] = range
        to_insert = ranges[(i + 1)..-1] # this range is bigger than before so we could overlap i+1 and more
        ranges = ranges[0..i]
        to_insert.each { |r| ranges = insert_range(ranges, r) }
        inserted = true
        i = 0
        ranges.sort!
      elsif ranges[i].cover? range
        # do nothing, range is already contained
        inserted = true
        i = 0
        ranges.sort!
      elsif range.begin <= ranges[i].begin
        range = range.begin..ranges[i].begin
        next_range = (range.end + 1)..ranges[i].end
        ranges.insert(i, range)
        ranges[i + 1] = next_range
        to_insert = ranges[(i + 2)..-1]
        ranges = ranges[0..(i + 1)]
        to_insert.each { |r| ranges = insert_range(ranges, r) }
        inserted = true
        i = 0
        ranges.sort!
      elsif range.begin >= ranges[i].begin
        prev_range = ranges[i].begin..range.begin
        range = (range.begin + 1)..range.end
        ranges.insert(i, prev_range)
        ranges[i + 1] = range
        to_insert = ranges[(i + 2)..-1]
        ranges = ranges[0..(i + 1)]
        to_insert.each { |r| ranges = insert_range(ranges, r) }
        inserted = true
        i = 0
        ranges.sort!
      end
    end
    i += 1 unless inserted
  end
  ranges << range unless inserted
  ranges.sort!
  ranges
end

line_at = 2000000
sbs = []

file.collect do |l|
  match = l.scan /Sensor at x=(.+), y=(.+): closest beacon is at x=(.+), y=(.+)/
  sbs << SensorBeacon.new(match[0][0].to_i, match[0][1].to_i, match[0][2].to_i, match[0][3].to_i)
end

ranges = []
file.close
sbs.each do |sb|
  dist_to_beacon = sb.dist
  dist_to_line = (sb.sy - line_at).abs
  extra_dist = dist_to_beacon - dist_to_line
  if extra_dist >= 0
    range = (sb.sx - extra_dist)..(sb.sx + extra_dist)
    ranges = insert_range(ranges, range)
  end
end

potential_beacons = ranges.sum { |r| r.length }
beacons_on_line = {}
sbs.each do |sb|
  if sb.by == line_at
    beacons_on_line["#{sb.bx}"] = ""
  end
end
puts potential_beacons - beacons_on_line.length