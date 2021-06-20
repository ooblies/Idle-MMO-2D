tool
extends TileMap

onready var fog = get_parent().get_node("Fog")
export(bool) var slow_generation = false

export(bool) var redraw setget redraw
func redraw(_value = null):
	if !Engine.is_editor_hint(): return
	
	generate()

export(int)   var iterations    = 20000
export(int)   var neighbors     = 4
export(int)   var ground_chance = 48
export(int)   var min_cave_size = 80
export(int)   var ladder_exit_loops = 10

enum Tiles { GROUND, ROOF, WALLS }
var caves = []
var ladder_locations = []
var previous_exit
var navigation
var map_w = 80
var map_h = 45

func _ready():
	yield(get_parent().get_node("Navigation"), "ready")
	navigation = get_parent().get_node("Navigation")
	map_w = get_parent().cave_size.x
	map_h = get_parent().cave_size.y
	generate()

#find all cells adjacent to fog
func get_exploration_target(current_position):
	var targets = []
	
	#find all ground tiles
	for cell_map in get_used_cells_by_id(Tiles.GROUND):
		var cell_position = map_to_world(cell_map)
		
		#that are not fogged
		var fog_map = fog.world_to_map(cell_position)
		if fog.get_cellv(fog_map) != fog.Tiles.FOG:
			
			#that are adjacent to fog
			var fog_map_UL = fog_map + Vector2(-1,-1)
			var fog_map_L = fog_map + Vector2(-1,0)
			var fog_map_BL = fog_map + Vector2(-1,1)
			var fog_map_U = fog_map + Vector2(0,-1)
			var fog_map_B = fog_map + Vector2(0,1)
			var fog_map_UR = fog_map + Vector2(1,-1)
			var fog_map_R = fog_map + Vector2(1,0)
			var fog_map_BR = fog_map + Vector2(1,1)
			
			
			if fog.get_cellv(fog_map_UL) == fog.Tiles.FOG || fog.get_cellv(fog_map_L) == fog.Tiles.FOG || fog.get_cellv(fog_map_BL) == fog.Tiles.FOG || fog.get_cellv(fog_map_U) == fog.Tiles.FOG || fog.get_cellv(fog_map_B) == fog.Tiles.FOG || fog.get_cellv(fog_map_UR) == fog.Tiles.FOG || fog.get_cellv(fog_map_R) == fog.Tiles.FOG || fog.get_cellv(fog_map_BR) == fog.Tiles.FOG:
				targets.append(cell_position)
	
	var closest_cell
	var closest_cell_distance
	for cell in targets:
		if closest_cell == null:
			closest_cell = cell
			closest_cell_distance = current_position.distance_to(cell)
		else:
			var new_dist = current_position.distance_to(cell)
			if new_dist < closest_cell_distance:
				closest_cell = cell
				closest_cell_distance = new_dist
	
	return closest_cell
	
func update_navigation():
	
	for cell in get_used_cells_by_id(Tiles.GROUND):
		navigation.add_point(cell)
		
	navigation._connect_traversable_tiles()

func clear_navigation():
	navigation.clear_navigation()

func find_ladder_locations():
	ladder_locations = []
	#find ground cells
	var ground_cells = get_used_cells_by_id(Tiles.GROUND)
	for cell in ground_cells:
		if check_nearby(cell.x, cell.y) == 0:
			ladder_locations.append(cell)

func set_ladder_locations():
	var exit_location
	var entrance_location
	
	if previous_exit == null:
		entrance_location = map_to_world(choose(ladder_locations))
	else:	
		entrance_location = previous_exit
		var entrance_map = world_to_map(entrance_location)
		set_cell(entrance_map.x - 1,entrance_map.y - 1,Tiles.GROUND)
		set_cell(entrance_map.x,entrance_map.y - 1,Tiles.GROUND)
		set_cell(entrance_map.x + 1,entrance_map.y - 1,Tiles.GROUND)
		set_cell(entrance_map.x - 1,entrance_map.y,Tiles.GROUND)
		set_cell(entrance_map.x,entrance_map.y,Tiles.GROUND)
		set_cell(entrance_map.x + 1,entrance_map.y,Tiles.GROUND)
		set_cell(entrance_map.x - 1,entrance_map.y + 1,Tiles.GROUND)
		set_cell(entrance_map.x,entrance_map.y + 1,Tiles.GROUND)
		set_cell(entrance_map.x + 1,entrance_map.y + 1,Tiles.GROUND)
		
		var searching = true
		var xmod = 1
		var ymod = 1
		while searching:
			print("Cave searching - " + str(xmod))
			
			var current_coords = Vector2(entrance_map.x - (1 + xmod),entrance_map.y - (1 + ymod))
			if get_cellv(current_coords) == Tiles.GROUND:
				print("Cave digging - " + str(xmod))
				create_tunnel(entrance_map,current_coords,[])
				break
				
				
			current_coords = Vector2(entrance_map.x,entrance_map.y - (1 + ymod))
			if get_cellv(current_coords) == Tiles.GROUND:
				print("Cave digging - " + str(xmod))
				create_tunnel(entrance_map,current_coords,[])
				break
			current_coords = Vector2(entrance_map.x + (1 + xmod),entrance_map.y - (1 + ymod))
			if get_cellv(current_coords) == Tiles.GROUND:
				print("Cave digging - " + str(xmod))
				create_tunnel(entrance_map,current_coords,[])
				break
			
			current_coords = Vector2(entrance_map.x - (1 + xmod),entrance_map.y)
			if get_cellv(current_coords) == Tiles.GROUND:
				print("Cave digging - " + str(xmod))
				create_tunnel(entrance_map,current_coords,[])
				break
			current_coords = Vector2(entrance_map.x + (1 + xmod),entrance_map.y)
			if get_cellv(current_coords) == Tiles.GROUND:
				print("Cave digging - " + str(xmod))
				create_tunnel(entrance_map,current_coords,[])
				break
			
			current_coords = Vector2(entrance_map.x - (1 + xmod),entrance_map.y + (1 + ymod))
			if get_cellv(current_coords) == Tiles.GROUND:
				print("Cave digging - " + str(xmod))
				create_tunnel(entrance_map,current_coords,[])
				break
			current_coords = Vector2(entrance_map.x,entrance_map.y + (1 + ymod))
			if get_cellv(current_coords) == Tiles.GROUND:
				print("Cave digging - " + str(xmod))
				create_tunnel(entrance_map,current_coords,[])
				break
			current_coords = Vector2(entrance_map.x + (1 + xmod),entrance_map.y + (1 + ymod))
			if get_cellv(current_coords) == Tiles.GROUND:
				print("Cave digging - " + str(xmod))
				create_tunnel(entrance_map,current_coords,[])
				break
			
			xmod = xmod + 1
			ymod = ymod + 1
	
	clear_navigation()
	update_navigation()
	
	var furthest_exit
	var furthest_exit_steps
	for _i in range(ladder_exit_loops):
		var current_exit = map_to_world(choose(ladder_locations))
		var current_exit_steps = 0
		var path = navigation.calculate_path(entrance_location,current_exit)
		if path != null:
			current_exit_steps = path.size()
		
		if furthest_exit == null:
			furthest_exit = current_exit
			furthest_exit_steps = current_exit_steps
		else:
			if current_exit_steps > furthest_exit_steps:
				furthest_exit = current_exit
				furthest_exit_steps = current_exit_steps
	exit_location = furthest_exit
	previous_exit = exit_location
	
	get_parent().set_exit_location(exit_location)
	get_parent().set_entrance_location(entrance_location)

func generate():
	print("Cave generating...")
	var cave_time = OS.get_system_time_msecs()
	clear_navigation()
	clear()
	fill_roof()
	random_ground()
	dig_caves()
	get_caves()
	connect_caves()
	update_navigation()
	find_ladder_locations()
	set_ladder_locations()
	update_bitmask_region()
	var cave_duration : float = OS.get_system_time_msecs() - cave_time
	print("Cave generated in " + str(cave_duration / 1000) + "s")
	
func fill_roof():
	for x in range(0, map_w):
		for y in range(0, map_h):
			set_cell(x, y, Tiles.WALLS)
			
func random_ground():
	for x in range(1, map_w-1):
		for y in range(1, map_h-1):
			if chance(ground_chance):
				set_cell(x, y, Tiles.GROUND)
				
func dig_caves():
	randomize()
	for _i in range(iterations):
		# Pick a random point with a 1-tile buffer within the map
		var x = floor(rand_range(1, map_w-1))
		var y = floor(rand_range(1, map_h-1))

		# if nearby cells > neighbors, make it a roof tile
		if check_nearby(x,y) > neighbors:
			set_cell(x, y, Tiles.WALLS)

		# or make it the ground tile
		elif check_nearby(x,y) < neighbors:
			set_cell(x, y, Tiles.GROUND)

func check_nearby(x, y):
	var count = 0
	if get_cell(x, y-1)   == Tiles.WALLS:  count += 1
	if get_cell(x, y+1)   == Tiles.WALLS:  count += 1
	if get_cell(x-1, y)   == Tiles.WALLS:  count += 1
	if get_cell(x+1, y)   == Tiles.WALLS:  count += 1
	if get_cell(x+1, y+1) == Tiles.WALLS:  count += 1
	if get_cell(x+1, y-1) == Tiles.WALLS:  count += 1
	if get_cell(x-1, y+1) == Tiles.WALLS:  count += 1
	if get_cell(x-1, y-1) == Tiles.WALLS:  count += 1
	return count
	
func get_caves():
	caves = []

	for x in range (0, map_w):
		for y in range (0, map_h):
			if get_cell(x, y) == Tiles.GROUND:
				flood_fill(x,y)

	for cave in caves:
		for tile in cave:
			set_cellv(tile, Tiles.GROUND)


func flood_fill(tilex, tiley):
	var cave = []
	var to_fill = [Vector2(tilex, tiley)]
	while to_fill:
		var tile = to_fill.pop_back()

		if !cave.has(tile):
			cave.append(tile)
			set_cellv(tile, Tiles.WALLS)

			#check adjacent cells
			var north = Vector2(tile.x, tile.y-1)
			var south = Vector2(tile.x, tile.y+1)
			var east  = Vector2(tile.x+1, tile.y)
			var west  = Vector2(tile.x-1, tile.y)

			for dir in [north,south,east,west]:
				if get_cellv(dir) == Tiles.GROUND:
					if !to_fill.has(dir) and !cave.has(dir):
						to_fill.append(dir)

	if cave.size() >= min_cave_size:
		caves.append(cave)
		
func connect_caves():
	var prev_cave = null
	var tunnel_caves = caves.duplicate()

	for cave in tunnel_caves:
		if prev_cave:
			var new_point  = choose(cave)
			var prev_point = choose(prev_cave)

			# ensure not the same point
			if new_point != prev_point:
				create_tunnel(new_point, prev_point, cave)

		prev_cave = cave


# do a drunken walk from point1 to point2
func create_tunnel(point1, point2, cave):
	randomize()          # for randf
	var max_steps = 500  # so editor won't hang if walk fails
	var steps = 0
	var drunk_x = point2[0]
	var drunk_y = point2[1]

	while steps < max_steps and !cave.has(Vector2(drunk_x, drunk_y)):
		steps += 1

		# set initial dir weights
		var n       = 1.0
		var s       = 1.0
		var e       = 1.0
		var w       = 1.0
		var weight  = 1

		# weight the random walk against edges
		if drunk_x < point1.x: # drunkard is left of point1
			e += weight
		elif drunk_x > point1.x: # drunkard is right of point1
			w += weight
		if drunk_y < point1.y: # drunkard is above point1
			s += weight
		elif drunk_y > point1.y: # drunkard is below point1
			n += weight

		# normalize probabilities so they form a range from 0 to 1
		var total = n + s + e + w
		n /= total
		s /= total
		e /= total
		w /= total

		var dx
		var dy

		# choose the direction
		var choice = randf()

		if 0 <= choice and choice < n:
			dx = 0
			dy = -1
		elif n <= choice and choice < (n+s):
			dx = 0
			dy = 1
		elif (n+s) <= choice and choice < (n+s+e):
			dx = 1
			dy = 0
		else:
			dx = -1
			dy = 0

		# ensure not to walk past edge of map
		if (2 < drunk_x + dx and drunk_x + dx < map_w-2) and \
			(2 < drunk_y + dy and drunk_y + dy < map_h-2):
			drunk_x += dx
			drunk_y += dy
			if get_cell(drunk_x, drunk_y) == Tiles.WALLS:
				set_cell(drunk_x, drunk_y, Tiles.GROUND)

				# optional: make tunnel wider
				set_cell(drunk_x+1, drunk_y, Tiles.GROUND)
				set_cell(drunk_x+1, drunk_y+1, Tiles.GROUND)
				
func chance(num):
	randomize()

	if randi() % 100 <= num:  return true
	else:                     return false

func choose(choices):
	randomize()

	var rand_index = randi() % choices.size()
	return choices[rand_index]

