class Valve # GabeN
  @name
  @flow
  @tunnels
  attr_reader :name, :flow
  attr_accessor :tunnels

  def initialize(name, flow)
    @name = name
    @flow = flow
    @tunnels = []
  end

  def to_s
    "(name=#{name}, flow=#{flow}, tunnels=[#{tunnels.collect { |t| t.name }.join(", ")}])\n"
  end

  def inspect
    self.to_s
  end

  def <=>(other)
    self.flow <=> other.flow
  end
end

class State
  @opened_valves
  @visited_valves
  @minute = 1
  @cur_valve = nil
  @flow = 0
  attr_accessor :opened_valves, :visited_valves, :minute, :cur_valve, :flow

  def initialize
    @opened_valves = {}
    @visited_valves = {}
    @minute = 1
    @cur_valve = nil
    @flow = 0
  end

  def clone
    new_state = State.new
    @opened_valves.each { |k, v| new_state.opened_valves[k] = v }
    @visited_valves.each { |k, v| new_state.visited_valves[k] = v }
    new_state.minute = self.minute
    new_state.cur_valve = self.cur_valve
    new_state.flow = self.flow
    new_state
  end

  def ==(other)
    raise "Wrong type #{other.class}" unless other.is_a? State
    self.opened_valves == other.opened_valves and
      self.visited_valves == other.visited_valves and
      self.minute == other.minute and
      self.cur_valve == other.cur_valve
  end

  alias eql? ==

  def hash

    self.opened_valves.hash ^
      self.visited_valves.hash ^
      self.minute.hash ^
      self.cur_valve.hash
  end
end

def read_input(valves)
  tunnels = {}
  nonzero_valves = 0
  file = File.open "day16in.txt"
  file.collect do |l|
    match = l.scan /Valve (\w\w) has flow rate=(\d+); tunnels? leads? to valves? (.*)/
    match[0][2..].each { |to| tunnels[match[0][0]] = to }
    valve = Valve.new(match[0][0], match[0][1].to_i)
    valves[match[0][0]] = valve
    nonzero_valves += 1 unless valve.flow.zero?
  end
  tunnels.each do |k, v|
    v.split(", ").each do |tunnel|
      valves[k].tunnels << valves[tunnel]
    end
  end
  file.close
  nonzero_valves
end

$valves = {}
$nonzero_valves = read_input $valves
puts $valves.inspect

state = State.new
state.cur_valve = $valves["AA"]
state.visited_valves["AA"] = ""
$max_flow = 0
$state_cache = {}

def next_sim(state)
  if $state_cache.key? state
    if $state_cache[state].flow >= state.flow
      # puts "retrieved from cache"
      return
    else
      $state_cache[state].flow = state.flow
      if state.flow > $max_flow
        $max_flow = state.flow
        puts "new max #{$max_flow}"
      end
      # puts "replaced flow in cache"
    end
  end
  if state.opened_valves.size == $nonzero_valves or state.minute > 30
    if state.flow > $max_flow
      $max_flow = state.flow
      puts "new max #{$max_flow}"
    end
    return
  end
  max_remaining_flow = 0
  reversed = ($valves.except(state.opened_valves.keys)).values.filter { |it| not it.flow.zero? }.sort.reverse
  reversed[0..((30 - state.minute) / 2)].each_with_index do |v, index|
    max_remaining_flow += ((30 - state.minute) - (index * 2)) * v.flow
  end
  if state.flow + max_remaining_flow < $max_flow
    return
  end
  unless state.cur_valve.flow.zero? or state.opened_valves.key? state.cur_valve.name # try turning on this valve
    new_state = state.clone
    new_state.flow += (30 - new_state.minute) * state.cur_valve.flow
    new_state.visited_valves.clear
    new_state.visited_valves[state.cur_valve.name] = ""
    new_state.opened_valves[state.cur_valve.name] = ""
    new_state.minute += 1
    next_sim(new_state)
    $state_cache[new_state] = new_state
  end
  state.cur_valve.tunnels.sort.reverse_each do |t|
    # try moving to other
    unless state.visited_valves.key? t.name
      new_state = state.clone
      new_state.cur_valve = t
      new_state.visited_valves[t.name] = ""
      new_state.minute += 1
      # don't recurse if all remaining valves are 0 flow
      next_sim(new_state) unless $valves.except(new_state.opened_valves.keys).all? { |k, v| v.flow.zero? }
      $state_cache[new_state] = new_state
    end
  end
  # $state_cache.delete state
end

starting = Time.now
next_sim state
puts Time.now - starting
puts $max_flow