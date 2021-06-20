extends TileMap

onready var cave : TileMap  = get_parent().get_node("Cave")
enum Tiles { FOG }
var fog_w = 80
var fog_h = 45
var fog_padding = 10
var light_distance = 5

func _ready():
	fog_w = get_parent().cave_size.x
	fog_h = get_parent().cave_size.y
	
	fill_fog()
	
func fill_fog():
	for x in range(-1 * fog_padding, fog_w + fog_padding):
		for y in range(-1 * fog_padding, fog_h + fog_padding):
			set_cell(x, y, Tiles.FOG)

func clear_fog(position):
	var coords = world_to_map(position)
	
	#within 1
	set_cellv(coords, -1)
	set_cellv(coords + Vector2(-1,-1),-1)
	set_cellv(coords + Vector2(-1,0),-1)
	set_cellv(coords + Vector2(-1,1),-1)
	set_cellv(coords + Vector2(0,-1),-1)
	set_cellv(coords + Vector2(0,1),-1)
	set_cellv(coords + Vector2(1,-1),-1)
	set_cellv(coords + Vector2(1,0),-1)
	set_cellv(coords + Vector2(1,1),-1)
	#within 2
	set_cellv(coords + Vector2(-2,-2),-1)
	set_cellv(coords + Vector2(-2,-1),-1)
	set_cellv(coords + Vector2(-2,0),-1)
	set_cellv(coords + Vector2(-2,1),-1)
	set_cellv(coords + Vector2(-2,2),-1)
	
	set_cellv(coords + Vector2(-1,-2),-1)
	set_cellv(coords + Vector2(-1,2),-1)
	set_cellv(coords + Vector2(0,-2),-1)
	set_cellv(coords + Vector2(0,2),-1)
	set_cellv(coords + Vector2(1,-2),-1)
	set_cellv(coords + Vector2(1,2),-1)
	
	set_cellv(coords + Vector2(2,-2),-1)
	set_cellv(coords + Vector2(2,-1),-1)
	set_cellv(coords + Vector2(2,0),-1)
	set_cellv(coords + Vector2(2,1),-1)
	set_cellv(coords + Vector2(2,2),-1)
	#within 3 sides
	
	set_cellv(coords + Vector2(-3,-2),-1)
	set_cellv(coords + Vector2(-3,-1),-1)
	set_cellv(coords + Vector2(-3,0),-1)
	set_cellv(coords + Vector2(-3,1),-1)
	set_cellv(coords + Vector2(-3,2),-1)
	
	set_cellv(coords + Vector2(-2,-3),-1)
	set_cellv(coords + Vector2(-1,-3),-1)
	set_cellv(coords + Vector2(-0,-3),-1)
	set_cellv(coords + Vector2(1,-3),-1)
	set_cellv(coords + Vector2(2,-3),-1)
	
	set_cellv(coords + Vector2(-2,3),-1)
	set_cellv(coords + Vector2(-1,3),-1)
	set_cellv(coords + Vector2(-0,3),-1)
	set_cellv(coords + Vector2(1,3),-1)
	set_cellv(coords + Vector2(2,3),-1)
	
	set_cellv(coords + Vector2(3,-2),-1)
	set_cellv(coords + Vector2(3,-1),-1)
	set_cellv(coords + Vector2(3,0),-1)
	set_cellv(coords + Vector2(3,1),-1)
	set_cellv(coords + Vector2(3,2),-1)
