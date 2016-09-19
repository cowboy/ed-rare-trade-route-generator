#!/usr/bin/env ruby

require 'fileutils'
require 'open-uri'
require 'csv'
require 'pp'

$project_name = 'Elite: Dangerous Rare Trade Route Generator'
$project_url = 'https://github.com/cowboy/ed-rare-trade-route-generator'
$project_version = '1.0.0'
$source_sheet_url = 'https://docs.google.com/spreadsheets/d/17Zv55yEjVdHrNzkH7BPnTCtXRs8GDHqchYjo9Svkyh4/edit#gid=0'

$csv_url = 'https://docs.google.com/feeds/download/spreadsheets/Export?key=17Zv55yEjVdHrNzkH7BPnTCtXRs8GDHqchYjo9Svkyh4&exportFormat=csv&gid=0'
$csv_file = 'ED_RareGoods_SystemsDistance - CURRENT.csv'
$output_dir = './routes'

$max_station_dist = 1000
$max_jump_dist = 90
$min_sell_dist = 160

$max_depth = 15
$max_jumps = 13
$best_count = 20

$warning_max_weight = 5
$max_allowed_undersells = 2
$min_required_sell_dist = 120
$max_goods_before_overflow = 4

$start_system = 'Leesti'

# ================
# MISC ARRAY STUFF
# ================

class Array
  # > %w{a b c d}.each_with_remainder {|a, b| puts "#{a} #{b}"}
  # a ["b", "c", "d"]
  # b ["a", "c", "d"]
  # c ["a", "b", "d"]
  # d ["a", "b", "c"]
  def each_with_remainder
    return to_enum :each_with_remainder unless block_given?
    self.each_index do |i|
      yield [self[i], self.slice(0, i) + self.slice(i+1..-1)]
    end
  end
  # > %w{a b c d}.map_with_remainder {|a, b| [a, b]}
  # => [["a", ["b", "c", "d"]],
  #  ["b", ["a", "c", "d"]],
  #  ["c", ["a", "b", "d"]],
  #  ["d", ["a", "b", "c"]]]
  def map_with_remainder
    return to_enum :map_with_remainder unless block_given?
    result = []
    self.each_index do |i|
      result << yield(self[i], self.slice(0, i) + self.slice(i+1..-1))
    end
    result
  end
  # > %w{a b c d}.map_cycle_remainder {|a, b| [a, b]}
  # => [["a", ["b", "c", "d"]],
  #  ["b", ["c", "d", "a"]],
  #  ["c", ["d", "a", "b"]],
  #  ["d", ["a", "b", "c"]]]
  def map_cycle_remainder
    return to_enum :map_cycle_remainder unless block_given?
    result = []
    self.each_index do |i|
      result << yield(self[i], self.slice(i+1..-1) + self.slice(0, i))
    end
    result
  end
end

# ==============================
# DOWNLOAD CSV FILE IF NECESSARY
# ==============================

unless File.exist? $csv_file
  print %Q{Downloading spreadsheet to "#{$csv_file}"...}
  File.open($csv_file, 'w') do |saved_file|
    open($csv_url, 'r') do |read_file|
      saved_file.write read_file.read
    end
  end
  puts 'done'
end

# ===============================
# PARSE CSV INTO SOMETHING USEFUL
# ===============================

# Parse CSV file into a usable data structure
headers = nil
coords_name_index = 6
system_name_index = 6
version_info_index = 7
$version_info = '???'
rows = []
system_names = []
coords = {}
print 'Parsing CSV data...'
CSV.read($csv_file).each do |row|
  row = row.map {|field| field.to_s.strip}
  if matches = row[version_info_index].match(/\AUpdate\s*:\s*(.*)\Z/)
    $version_info = matches[1]
  elsif matches = row[coords_name_index].match(/\A[xyz]\Z/)
    coords[matches[0]] = row
  elsif row[system_name_index] == 'SYSTEM'
    if headers
      break
    else
      headers = row
    end
  elsif headers
    rows << row
    system_names << row[system_name_index]
  end
end

# Parse system x,y,z coords
%w{x y z}.each_with_index do |axis, index|
  headers.zip(coords[axis]).each do |arr|
    system, coord = arr
    next unless system_names.include? system
    (coords[system] ||= [])[index] = coord.to_f
  end
  coords.delete axis
end
puts 'done'

puts "Update: #{$version_info}"

# Normalize per-system data and generate a systems map
print 'Normalizing system data...'
$systems = {}
rows.each do |row|
  data = Hash[headers.zip(row)]
  meta = data.reject {|k,v| system_names.include? k}
  data.select! {|k,v| system_names.include? k}
  data = Hash[data.map {|k,v| [k, v.to_f]}]

  system_name = meta['SYSTEM']
  $systems[system_name] ||= {}

  system = $systems[system_name]
  system[:distance] ||= data
  system[:system_name] ||= system_name
  system[:coordinates] ||= coords[system_name]
  system[:goods] ||= []

  # Item details
  system[:goods] << (good = {})
  good[:name] = meta['ITEM']
  good[:price] = meta['PRICE'].gsub(/\D/, '').to_i
  min, max = meta['SUPPLY RATE'].match(/ND|(\d+)(?:-(\d+))?/).captures
  good[:supply_min] = min.to_i || 0
  good[:supply_max] = max ? max.to_i : good[:supply_min]
  good[:cap] = (meta['MAX CAP'].gsub(/\D/, '') || '0').to_i
  good[:station_name] = meta['STATION']

  # Distance from star to station
  dist = meta['DIST(Ls)'].gsub /,/, ''
  good[:station_dist] = if matches = dist.match(/(\d+)\s*Ly/i)
    matches[0].to_f * 31556926
  elsif dist.match /ND/i
    Float::INFINITY
  else
    dist.to_f
  end
end
puts 'done'

# =========================================
# FILTER OUT SYSTEMS WE DON'T WANT TO GO TO
# =========================================

print 'Removing systems with distant stations / missing routes...'
# To help keep track of what systems are removed
system_names = $systems.keys

# Remove stations too far away from their sun
$systems.reject! do |system_name, system|
  system[:goods].select! {|good| good[:station_dist] < $max_station_dist}
  system[:goods].empty?
end

# Get route-plannable systems and systems to sell to, sorted
# by proximity (nearest first)
$systems.select! do |system, data|
  data[:distance].to_a.sort {|a, b| a[1] <=> b[1]}.each do |arr|
    target, distance = arr
    if distance > 0 and distance <= $max_jump_dist
      (data[:max_jump_dist] ||= []) << target
    elsif distance >= $min_sell_dist
      (data[:min_sell_dist] ||= []) << target
    end
  end
  # Only keep systems that can possibly work!
  data[:max_jump_dist] and data[:min_sell_dist]
end

# Remove distances for removed systems
removed_systems = system_names - $systems.keys
$systems.each do |system_name, system|
  removed_systems.each do |removed_system_name|
    %w{distance max_jump_dist min_sell_dist}.each do |key|
      system[key.to_sym].delete removed_system_name
    end
  end
end
puts 'done'

# ===============================================
# FEEBLE ATTEMPT TO MAKE ROUTING FASTER / SMARTER
# ===============================================

# Group "nearby" systems, ie. systems that are close enough to share the
# exact same route-plannable systems
print 'Grouping nearby systems...'
$systems.reduce({}) do |memo, arr|
  system_name, system = arr
  nearby = (system[:max_jump_dist] + [system_name]).sort
  (memo[nearby] ||= []) << system_name
  memo
end.values.select do |nearby|
  nearby.length > 1
end.each do |nearby|
  nearby.each_with_remainder do |system_name, remainder|
    $systems[system_name][:nearby] = remainder
  end
end
puts 'done'

# ==============================================================
# BUILD ROUTES BY HITTING MANY NAILS WITH A SINGLE, LARGE HAMMER
# ==============================================================

# Recursively, brute-force attempt to build circular routes
def get_routes(route)
  route = [route] unless route.kind_of? Array
  $routes = []
  $routes_sorted = []
  $loop_count = 0
  $max_depth_seen = 0
  $max_jumps_seen = 0
  get_routes_recurse route, 0
  all_done
end

def get_routes_recurse(route, depth)
  # print "\r#{route}"
  # The route is a loop. Check validity.
  return found_route(route[0..-2], depth) if route.length > 1 and route.last == route.first
  $max_depth_seen = [$max_depth_seen, depth].max
  $max_jumps_seen = [$max_jumps_seen, route.length].max
  # Reject this route if too deep (we don't want really long routes, anyways)
  return if depth == $max_depth
  # Reject this route if too long
  return if route.length > $max_jumps
  # If there are any, add all "nearby" systems to the route
  route += $systems[route.last][:nearby] if $systems[route.last].has_key? :nearby
  # Attempt to continue route for each system not already in the route
  # (except for the start system) that is within max_jump_dist
  all_but_first = route[1..-1]
  $systems[route.last][:max_jump_dist].each do |target|
    next if all_but_first.include? target
    get_routes_recurse route + [target], depth + 1
  end
end

def p(*args)
  $p_output << (args.empty? ? '' : sprintf(*args))
end

def p1(*args)
  p(*args)
  p
end

$files_written = {}
def write_to_file(filename, text)
  text = text.join "\n" if text.kind_of? Array
  mode = 'a'
  unless $files_written.has_key? filename
    $files_written[filename] = true
    FileUtils.mkdir_p $output_dir unless File.directory? $output_dir
    mode = 'w'
  else
    text = "\n---\n\n#{text}"
  end
  open("#{$output_dir}/#{filename}", mode) {|f| f.puts text}
end

def found_route(route, depth)
  $loop_count += 1
  # puts "loop: #{route}"

  # Reject this route if it contains the same systems as another route
  sorted = route.sort
  return if $routes_sorted.include? sorted

  # Find the farthest point in the route to sell each item, noting any
  # points that are less than min_sell_dist
  undersells = []
  sell_goods_at = route.map_cycle_remainder do |buy, sells|
    distances = $systems[buy][:distance]
    unless result = sells.find {|sell| distances[sell] >= $min_sell_dist}
      result = sells.max {|a, b| distances[a] <=> distances[b]}
      # Reject this route if any good can't be sold at this minimum distance
      return if distances[result] < $min_required_sell_dist
      undersells << [buy, result]
    end
    [buy, result]
  end.each_with_object(Hash.new {[]}) do |arr, obj|
    buy, sell = arr
    obj[sell] += [buy]
  end

  # Find systems with heavily clustered goods-to-be-sold
  overflows = sell_goods_at.map do |buy, sells|
    max = sells.reduce(0) do |sum, system_name|
      sum + $systems[system_name][:goods].length
    end
    [buy, max]
  end.select {|arr| arr[1] > $max_goods_before_overflow}

  # Compute warnings
  warnings = []
  overflows.each do |arr|
    system_name, count = arr
    warnings << {weight: 2, message: "Possible cargo overflow (#{count} goods @ #{system_name})"}
  end
  undersells.each do |arr|
    system_name, target = arr
    distance = $systems[system_name][:distance][target]
    warnings << {weight: 1, message: "Suboptimal sell distance: #{system_name} -> #{target} (#{distance} Ly)"}
  end
  warning_weight = warnings.reduce(0) {|s, obj| s + obj[:weight]}

  # Reject if the warnings are too severe
  return if warning_weight > $warning_max_weight

  # Consider this route valid!
  $routes_sorted << sorted

  # Compute complete route distance
  route_distance = 0
  route.each_with_index do |system_name, index|
    route_distance += $systems[system_name][:distance][route[index + 1] || route.first]
  end

  status = sprintf 'Route #%d (Warnings: %d, Jumps: %d, Distance: %.2f Ly, Depth: %d, Loop: %d)',
                   $routes.length + 1, warnings.length, route.length, route_distance, depth, $loop_count
  status += ' PERFECT' if warnings.empty?
  puts status

  $p_output = []
  p1 '## Rare Trade Route #%d', $routes.length + 1
  p 'Generated by [%s v%s](%s) at %s', $project_name, $project_version,
    $project_url, Time.now.to_s
  p1 'using data from [ED_RareGoods_SystemsDistance (%s)](%s).', $version_info,
    $source_sheet_url
  unless warnings.empty?
    p1 '#### Warnings'
    warnings.each {|obj| p '* %s', obj[:message]}
    p
  end

  # Print per-system details
  p1 '#### Route'
  p1 'Jumps: %d, Distance: %.2f Ly', route.length, route_distance
  route.each_with_index do |system_name, index|
    system = $systems[system_name]
    distance_to_next = system[:distance][route[index + 1] || route.first]
    p '%-3s %s (%.2f Ly)', "#{index + 1}.", system_name, distance_to_next
    sell_goods_at[system_name].each do |source|
      distance = system[:distance][source]
      $systems[source][:goods].each do |good|
        p '    * [SELL] %s (%s @ %.2f Ly)', good[:name], source, distance
      end
    end if sell_goods_at.has_key? system_name
    system[:goods].each do |good|
      name, cap, station_name, station_dist = good.values_at :name, :cap, :station_name, :station_dist
      p '    * [BUY] %s x %d (%s @ %d Ls)', name, cap, station_name, station_dist
    end
  end
  p

  filename = "#{warnings.empty? ? 'perfect' : "warnings-#{warning_weight}"}-jumps-#{route.length}.markdown"
  write_to_file filename, $p_output

  $routes << {
    route: route,
    warning_weight: warning_weight,
    distance: route_distance,
    output: $p_output,
  }
end

def all_done
  puts "\nDone!"
  perfect, imperfect = $routes.partition {|route| route[:warning_weight] == 0}
  lines = [
    ['Number of loops found', $loop_count],
    ['Number of routes found', $routes.length],
    ['Number of perfect routes found', perfect.length],
    ['Number of imperfect routes found', imperfect.length],
    ['Max depth seen', $max_depth_seen],
    ['Max jumps seen', $max_jumps_seen],
  ]
  w_lefts, w_rights = lines.map {|arr| arr.map {|s| s.to_s.length}}.transpose
  w_left, w_right = w_lefts.max, w_rights.max
  width = w_left + w_right + 3

  header = 'POSSIBLY-INTERESTING STATISTICS'
  banner = [nil, "#{' ' * ((width - header.length) / 2)}#{header}", nil]
  banner += lines.map do |left, right|
    "#{left.to_s.ljust w_left + 3, '.'}#{right.to_s.rjust w_right, '.'}"
  end << nil
  banner = banner.map {|s| s or '=' * width}.join "\n"
  puts "\n#{banner}"

  routes = perfect.sort_by {|obj| [obj[:route].length, obj[:distance]]}
  routes += imperfect.sort_by {|obj| [obj[:warning_weight], obj[:route].length, obj[:distance]]}
  routes[0..$best_count-1].each do |route|
    write_to_file "best-#{$best_count}.markdown", route[:output]
  end

  puts "\nSORRY, NO ROUTES FOUND!" if routes.empty?
end

puts 'Calculating routes...'
get_routes $start_system

