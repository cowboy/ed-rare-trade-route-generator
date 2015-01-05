#!/usr/bin/env ruby

require 'fileutils'
require 'open-uri'
require 'csv'
require 'pp'

$project_name = 'Elite: Dangerous Rare Trade Route Generator'
$project_url = 'https://github.com/cowboy/ed-rare-trade-route-generator'
$project_version = '1.0.0'
$source_sheet_url = 'https://docs.google.com/spreadsheets/d/1_Qd8cXXGnC5vAUhutONW2Fqr5kk_BVd7jWesdBgP-yA/edit#gid=0'

$csv_url = 'https://docs.google.com/feeds/download/spreadsheets/Export?key=1haUVaFIxFq5IPqZugJ8cfCEqBrZvFFzcA-uXB4pTfW4&exportFormat=csv&gid=0'
$csv_file = 'ED_RareGoods_SystemsDistance - CURRENT.csv'
$output_dir = './routes'

$max_jump_dist = 90
$min_sell_dist = 160

$max_depth = 15
$max_jumps = 13
$best_count = 20

$max_station_dist = 1000
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
$version_info = nil
headers = nil
coords_name_index = 6
system_name_index = 6
version_info_index = 7
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
%w{x y z}.each_with_index do |axis, i|
  headers.zip(coords[axis]).each do |arr|
    system, coord = arr
    next unless system_names.include? system
    (coords[system] ||= [])[i] = coord.to_f
  end
  coords.delete axis
end
puts 'done'

puts "Update: #{$version_info}"

# Normalize per-system data and generate a systems map
print 'Normalizing system data...'
systems = {}
rows.each do |row|
  data = Hash[headers.zip(row)]
  meta = data.reject {|k,v| system_names.include? k}
  distance = Hash[data.select {|k,v| system_names.include? k}.map {|k,v| [k, v.to_f]}]

  system_name = meta['SYSTEM']
  systems[system_name] ||= {}

  system = systems[system_name]
  system[:distance] ||= distance
  system[:coordinates] ||= coords[system_name]
  system[:goods] ||= []

  # Goods details
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

# ==============================
# GENERATE ARRAYS OF SYSTEM DATA
# ==============================

$system_names = []
$coordinates = []
$goods = []

# Sort systems alphabetically first, then generate arrays
systems.to_a.sort {|a, b| a[0] <=> b[0]}.each do |system_name, system|
  $system_names << system_name
  $coordinates << system[:coordinates]
  $goods << system[:goods]
end

# Build system indices
$system_index = {}
$system_names.each_with_index do |system_name, i|
  $system_index[system_name] = i
end

# Compute distances (could also use the pre-computed distance info)
$distance = $coordinates.map do |x1, y1, z1|
  $coordinates.map do |x2, y2, z2|
    Math.sqrt( (x1 - x2)**2 + (y1 - y2)**2 + (z1 - z2)**2 )
  end
end

# Nothing is rejected yet!
$rejects = Array.new systems.length

puts "Systems found: #{$system_names.length}"

# =========================================
# FILTER OUT SYSTEMS WE DON'T WANT TO GO TO
# =========================================

puts 'Removing systems with distant stations / missing routes...'

# Remove stations too far away from their sun
$goods.each_with_index do |goods, i|
  if goods.select {|good| good[:station_dist] < $max_station_dist}.empty?
    puts "Removed [#{i}] #{$system_names[i]}, Station more than #{$max_station_dist} Ls from sun"
    $rejects[i] = true
  end
end

# Process $routable and $sellable together
$routable = []
$sellable = []
# rs_arrays = [$routable, $sellable]
rs_arrays = [$routable]

# Get route-plannable systems and systems to sell to, sorted
# by proximity (nearest first)
$distance.each_with_index do |distances, i|
  next if $rejects[i]
  rs_arrays.each {|a| a[i] = []}
  distances.each_with_index do |distance, j|
    if i == j || $rejects[j]
      next
    elsif distance <= $max_jump_dist
      $routable[i] << j
    elsif distance >= $min_sell_dist
      $sellable[i] << j
    end
  end
end

# Iteratively remove rejected systems from $routable and $sellable
loop do
  rejects = rs_arrays.map {|a| a.map.with_index.select {|systems, i| systems == []}}.flatten.uniq.compact
  break if rejects.empty?
  $rejects.each_with_index do |state, i|
    if rejects.include? i
      puts "Removed [#{i}] #{$system_names[i]}, No systems <= #{$max_jump_dist} Ly (jump) and >= #{$min_sell_dist} Ly (sell)"
      $rejects[i] = true
      rs_arrays.each {|a| a[i] = nil}
    else
      rs_arrays.each {|a| a[i].reject! {|j| rejects.include? j} if a[i]}
    end
  end
end

puts "Systems remaining: #{$rejects.reject {|a| a}.length}"

# #############################################################################
# $items = %w{a B c D E f g h i j k}

# def get_route(indices, remain, used, route)
#   Enumerator.new do |y|
#     if remain == 0
#       # Abort if route is a reversal of another route
#       next if route[1] > route.last
#       # Valid route!
#       y << route
#       next
#     end
#     # Recurse
#     indices.each do |i|
#       next if used.include? i
#       get_route(indices, remain - 1, used + [i], route + [i]).each do |route|
#         y << route
#       end
#     end
#   end#.lazy
# end

# def get_routes(size)
#   cache_file = "routes-#{size}.bin"
#   cache_path = "cache/#{cache_file}"
#   exists = File.exist? cache_path
#   indices = $items.map.with_index {|a,i| i}
#   f = File.open(cache_path, exists ? 'rb' : 'wb')
#   start = Time.now
#   if exists
#     print "Reading cache file #{cache_file}..."
#     Enumerator.new do |y|
#       loop do
#         chunk = f.read(size * 2)
#         if chunk.nil?
#           printf("done (%.1fs)\n", Time.now - start)
#           f.close
#           break
#         end
#         y << chunk.unpack('s' * size)
#       end
#     end
#   else
#     print "Writing cache file #{cache_file}..."
#     Enumerator.new do |y|
#       indices.each_with_object([]) do |i, used|
#         get_route(indices, size - 1, used << i, [i]).each do |route|
#           f << route.pack('s' * size)
#           y << route
#         end
#       end
#       printf("done (%.1fs)\n", Time.now - start)
#       f.close
#     end
#   end
# end

# $a = $b = 0
# (6..$items.length).each do |length|
#   get_routes(length).each do |route|
#     $a += 1
#     # route = route.map {|i| $items[i]}.join('')
#     # puts "#{route}"
#     # $b += 1 if /BED/.match route
#   end
# end
# puts "total: #{$a}, bed: #{$b}"
# exit
# #############################################################################

# http://pastebin.com/xBgj7C7B
def get_route(systems, remain, used, route)
  Enumerator.new do |y|
    # Abort if start system can't possibly be returned to
    if $distance[route.first][route.last] > $max_jump_dist * (remain + 1)
      next
    # Length reached
    elsif remain == 0
      # Abort if route is a reversal of another route
      next if route[1] > route.last
      # Valid route!
      y << route
      next
    end
    # Recurse
    $routable[route.last].each do |i|
      next if used.include? i
      get_route(systems, remain - 1, used + [i], route + [i]).each do |route|
        y << route
      end
    end
  end
end

def get_routes_cached(size)
  cache_file = "routes-#{size}-#{$max_jump_dist}-#{$max_station_dist}.bin"
  cache_path = "cache/#{cache_file}"
  if File.exist? cache_path
    f = File.open cache_path, 'rb'
    Enumerator.new do |y|
      loop do
        chunk = f.read size
        if chunk.nil?
          f.close
          break
        end
        y << chunk.unpack('C' * size)
      end
    end
  else
    f = File.open cache_path, 'wb'
    start = Time.now
    Enumerator.new do |y|
      get_routes(size).each do |result|
        f << result.pack('C' * size)
        y << result
      end
      printf("Done writing %s in %.1fs\n", cache_file, Time.now - start)
      f.close
    end
  end
end


def get_routes(size)
  systems = $routable.compact.flatten.sort.uniq
  Enumerator.new do |y|
    systems.each_with_object([]) do |i, used|
      get_route(systems, size - 1, used << i, [i]).each do |route|
        y << route
      end
    end
  end
end

n = 0
(4..13).each do |length|
  m = 0
  get_routes_cached(length).each do |route|
    m += 1
    n += 1
    # puts "#{route}"
  end
  puts "=> #{m} routes of length #{length}"
end
puts "=> #{n} routes total"



exit

# ===============================================
# FEEBLE ATTEMPT TO MAKE ROUTING FASTER / SMARTER
# ===============================================

$nearby = []

# Group "nearby" systems, ie. systems that are close enough to share the
# exact same route-plannable systems
print 'Grouping nearby systems...'
$systems.reduce({}) do |memo, arr|
  system_name, system = arr
  nearby = (system[:routable] + [system_name]).sort
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
  # (except for the start system) that is within routable
  all_but_first = route[1..-1]
  $systems[route.last][:routable].each do |target|
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

