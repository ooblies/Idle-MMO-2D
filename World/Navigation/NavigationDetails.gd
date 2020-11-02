extends TileMap

export(bool) var is_disabled = false
export(float) var disabled_radius = 8
export(float) var weight = 1

onready var navigation = get_owner().get_node("Navigation")

func _ready():
	yield(navigation, "ready")
	
	for cell in get_used_cells():
		if is_disabled:
			#print("Disabling point at " + str(map_to_world(cell)))
			navigation.disable_point(map_to_world(cell), disabled_radius)
	
		if weight != 0:
			#print("Changing path weight at " + str(map_to_world(cell)) + " to " + str(weight))
			navigation.set_point_weight(map_to_world(cell), weight)

