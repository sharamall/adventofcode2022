before = Time.now
puts "starting at #{before}"
file = File.open "day19in.txt"

blueprints = file.collect do |l|
  results = l.scan /Blueprint (\d+): Each ore robot costs (\d+) ore\. Each clay robot costs (\d+) ore\. Each obsidian robot costs (\d+) ore and (\d+) clay\. Each geode robot costs (\d+) ore and (\d+) obsidian\./
  {
    ore_cost: results[0][1].to_i,
    clay_cost: results[0][2].to_i,
    obs_cost: { ore: results[0][3].to_i, clay: results[0][4].to_i },
    geode_cost: { ore: results[0][5].to_i, obs: results[0][6].to_i },
    bp_id: results[0][0].to_i
  }
end

def collect_and_build(state, to_build)
  # collect resources
  state[:ore] += state[:ore_robots]
  state[:clay] += state[:clay_robots]
  state[:obs] += state[:obs_robots]
  state[:geo] += state[:geo_robots]

  # finish build
  state["#{to_build}_robots".to_sym] += 1 unless to_build.nil?
end

class GeodeFinder
  @max_geo
  @earliest_geode
  @earliest_obs
  @bp_id
  @cache
  attr_reader :max_geo, :bp_id

  def initialize(id)
    @max_geo = 0
    @earliest_geode = 32
    @earliest_obs = 32
    @bp_id = id
    @cache = {}
  end

  def to_cache_key(state, day)
    "#{state[:ore]}_#{state[:ore_robots]}_#{state[:clay]}_#{state[:clay_robots]}_#{state[:obs]}_#{state[:obs_robots]}_#{state[:geo]}_#{state[:geo_robots]}_#{day}".freeze
  end

  def max_geodes(bp, state, day)
    if day == 32
      collect_and_build(state, nil) # never need to build on the last day
      puts "bp: #{@bp_id} max_geo at 32 #{state[:geo]}" if state[:geo] > @max_geo
      @max_geo = [@max_geo, state[:geo]].max
      return state[:geo]
    end
    key = to_cache_key(state, day)
    cache_val = @cache[key]
    return cache_val unless cache_val.nil?

    res = []

    max_possible_geodes = (32 + 1 - day) * (32 - day) / 2 # n(n-1)/2
    # max possible is new geodes if we make only geo robots today out
    # y=n(n-1)/2 crosses y = n at n = 3
    if (max_possible_geodes + state[:geo] + state[:geo_robots] * (32 - (day - 1))) < @max_geo # max possible is creating a geode at every time stamp from here on out
      res << 0
    else
      # check build robots
      if state[:ore] >= bp[:geode_cost][:ore] and state[:obs] >= bp[:geode_cost][:obs]
        new_state = eval(state.inspect)
        new_state[:ore] -= bp[:geode_cost][:ore]
        new_state[:obs] -= bp[:geode_cost][:obs]
        collect_and_build(new_state, :geo)
        res << max_geodes(bp, new_state, day + 1)
        # geode_rate = (32 - day) * new_state[:geo_robots] + ([bp[:geode_cost][:obs] * 1.0 / new_state[:obs_robots], bp[:geode_cost][:ore] * 1.0 / new_state[:ore_robots]].max.ceil)
        # puts "geode rate #{geode_rate} at day #{day}"
        @earliest_geode = [day, @earliest_geode].min
      end

      if state[:ore] >= bp[:obs_cost][:ore] and state[:clay] >= bp[:obs_cost][:clay]
        new_state = eval(state.inspect)
        new_state[:ore] -= bp[:obs_cost][:ore]
        new_state[:clay] -= bp[:obs_cost][:clay]
        collect_and_build(new_state, :obs)
        res << max_geodes(bp, new_state, day + 1)
        # @earliest_obs = [day, @earliest_obs].min
        # elsif day > @earliest_obs and state[:obs_robots].zero?
        #   return 0
      end

      if state[:ore] >= bp[:clay_cost]
        new_state = eval(state.inspect)
        new_state[:ore] -= bp[:clay_cost]
        collect_and_build(new_state, :clay)
        res << max_geodes(bp, new_state, day + 1)
      end

      if state[:ore] >= bp[:ore_cost]
        new_state = eval(state.inspect)
        new_state[:ore] -= bp[:ore_cost]
        collect_and_build(new_state, :ore)
        res << max_geodes(bp, new_state, day + 1)
      end

      new_state = eval(state.inspect)
      collect_and_build(new_state, nil)
      res << max_geodes(bp, new_state, day + 1)
    end

    max_geodes_found = res.max
    @cache[key] = max_geodes_found
    max_geodes_found
  end
end

threads = []
Thread.abort_on_exception = true
blueprints = blueprints[0..2]
blueprints.each do |bp|
  gf = GeodeFinder.new(bp[:bp_id])
  item = { thread: Thread.new {
    # _i = receive
    # _bp = receive
    # _i = i
    _bp = bp
    gf.max_geodes(_bp, {
      ore: 0,
      ore_robots: 1,
      clay: 0,
      clay_robots: 0,
      obs: 0,
      obs_robots: 0,
      geo: 0,
      geo_robots: 0
    }, 1)
    gf
  }, gf: gf }
  # item.send i
  # item.send bp, move: true # bp no longer accessible from out here
  threads << item
end
product = 1
threads.each do |t|
  t[:thread].join
  product *= t[:gf].max_geo
end

puts product
puts "took: #{Time.now - before}"