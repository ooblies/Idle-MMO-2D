extends TileMap

# Reference to a new AStar navigation grid node
onready var astar : AStar2D = AStar2D.new()

# Used to find the centre of a tile
onready var half_cell_size = cell_size / 2

onready var rect_size = get_used_rect()

# All tiles that can be used for pathfinding
onready var traversable_tiles = get_used_cells()

var connections = 0

export var default_weight : float = 4
export var draw_connections : bool = false
export var draw_paths : bool = false


func _ready():
	var astar_time = OS.get_system_time_msecs()
	# Add all tiles to the navigation grid
	_add_traversable_tiles()

	# Connects all added tiles
	_connect_traversable_tiles()
	var astar_duration : float = OS.get_system_time_msecs() - astar_time
	
	print("A* Calculation - " + str(astar_duration / 1000) + "s")
	print("Traversable Tiles - " + str(traversable_tiles.size()))
	print("Connections - " + str(connections))
	
	


## Private functions
func clear_navigation():
	clear()
	astar.clear()
	for child in get_children():
		child.queue_free()
	traversable_tiles = []

# Adds tiles to the A* grid but does not connect them
# ie. They will exist on the grid, but you cannot find a path yet
func _add_traversable_tiles():

	# Loop over all tiles
	for tile in traversable_tiles:

		# Determine the ID of the tile
		var id = _get_id_for_point(tile)

		# Add the tile to the AStar navigation
		astar.add_point(id, Vector2(tile.x, tile.y), default_weight)
		
		#print("tile #" + str(id) + " - " + str(tile) + " - " + str(map_to_world(tile)))
		

# Connects all tiles on the A* grid with their surrounding tiles
func _connect_traversable_tiles():
	# Loop over all tiles
	for tile in traversable_tiles:
		
		# Determine the ID of the tile
		var id = _get_id_for_point(tile)

		# Loops used to search around player (range(3) returns 0, 1, and 2)
		for x in range(3):
			for y in range(3):

				# Determines target, converting range variable to -1, 0, and 1
				var target = tile + Vector2(x - 1, y - 1)

				# Determines target ID
				var target_id = _get_id_for_point(target)

				# Do not connect if point is same or point does not exist on astar
				if tile == target or not astar.has_point(target_id):
					continue
					
				# Do not connect if point is already connected to target
				if astar.are_points_connected(id, target_id):
					continue

				# Connect points
				astar.connect_points(id, target_id, true)
				connections += 1
				
				if draw_connections:					
					#print (str(tile) + " connects to " + str(target))

					var p = map_to_world(tile)
					p.x += half_cell_size.x
					p.y += half_cell_size.y
					var p2 = map_to_world(target)
					p2.x += half_cell_size.x
					p2.y += half_cell_size.y
					var l = Line2D.new()
					l.points=[p,p2]
					l.width = 1
					l.default_color = Color.white
					add_child(l)
				


# Determines a unique ID for a given point on the map
func _get_id_for_point(point):		
	#var xx = x >= 0 ? x * 2 : x * -2 - 1;
	var xx = 0
	if point.x >= 0:
		xx = point.x * 2
	else:
		xx = point.x * -2 - 1
	
	#var yy = y >= 0 ? y * 2 : y * -2 - 1;
	var yy = 0
	if point.y >= 0:
		yy = point.y * 2
	else:
		yy = point.y * -2 - 1
	
	var id = 0
	#(xx >= yy) ? (xx * xx + xx + yy) : (yy * yy + xx);
	if xx >= yy:
		id = xx * xx + xx + yy
	else:
		id = yy * yy + xx
	#point -= rect_size.position
	#var id = point.y * rect_size.size.x + point.x
	return id


## Public functions

# Returns a path from start to end
# These are real positions, not cell coordinates
func calculate_path(start, end):

	var path_time = OS.get_system_time_msecs()
	# Convert positions to cell coordinates
	var start_tile = world_to_map(start)
	var end_tile = world_to_map(end)

	# Determines IDs
	var start_id = _get_id_for_point(start_tile)
	var end_id = _get_id_for_point(end_tile)

	# Return null if navigation is impossible
	if not astar.has_point(start_id) or not astar.has_point(end_id):
		#print("No path found.")
		return null

	# Otherwise, find the map
	var path_map = astar.get_point_path(start_id, end_id)

	# Convert Vector2 array to real world points
	var path_world = []
	for point in path_map:
		var point_world = map_to_world(Vector2(point.x, point.y)) + half_cell_size
		path_world.append(point_world)
		
	if draw_paths:
		var line = Line2D.new()
		line.points = path_world
		line.default_color = Color.white
		line.width = 2.0
		add_child(line)
	
	var path_duration : float = OS.get_system_time_msecs() - path_time
	#print("Calculate path from " + str(start) + " to " + str(end))
	#print warning if long calculate time
	if path_duration >= 100:
		print("WARNING - Time to calculate path - " + str(path_duration / 1000) + "s")
	return path_world

func add_point(point : Vector2):
	set_cell(point.x, point.y,0)
	
	traversable_tiles.append(point)
	var id = _get_id_for_point(point)
	astar.add_point(id, Vector2(point.x, point.y), default_weight)

func disable_point(point : Vector2, radius : float):
	radius = radius * sqrt(2.0)
	radius = round_to_dec(radius, 2)
	#print("disable within " + str(radius) + " of " + str(point))
	for a_point in astar.get_points():
		var a_point_world = map_to_world(astar.get_point_position(a_point))
		a_point_world.x += half_cell_size.x
		a_point_world.y += half_cell_size.x
		if a_point_world.distance_to(point) <= radius:
			#print("disable - #" + str(a_point) + " - " + str(a_point_world))
			astar.set_point_disabled(a_point)

func set_point_weight(point : Vector2, weight : float):	
	var point_tile = world_to_map(point)
	var id = _get_id_for_point(point_tile)
	#var exists = astar.has_point(id)
	#var a_point = astar.get_point_position(id)
	#var a_point_world = map_to_world(a_point)
	#var test_weight = astar.get_point_weight_scale(id)
	#print("point #" + str(id) + " - " + str(a_point_world) + " - weight = " + str(test_weight))
	if astar.has_point(id):
		astar.set_point_weight_scale(id, weight)
	
	#test_weight = astar.get_point_weight_scale(id)
	#print("point #" + str(id) + " - " + str(a_point_world) + " - weight = " + str(test_weight))


func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
