extends Node2D

onready var entrance = $CaveFloorEntrance
onready var exit = $CaveFloorExit
onready var tilemap : TileMap = $Cave
onready var fog : TileMap = $Fog

var cave_size = Vector2(80,45)


func get_locations():
	if entrance == null:
		entrance = get_node("CaveFloorEntrance")
	if exit == null:
		exit = get_node("CaveFloorExit")
	if tilemap == null:
		tilemap = $Cave
		
func set_entrance_location(location):
	get_locations()
	entrance.position = location
	
	for character in get_tree().get_nodes_in_group("Characters"):
		character.position = location
		#var target_pos = tilemap.get_exploration_target(character.position)
		#character.set_cave_path(target_pos)

func set_exit_location(location):
	get_locations()
	exit.position = location

func _process(delta):
	var chars = get_tree().get_nodes_in_group("Characters")
	
	for c in chars:
		fog.clear_fog(c.global_position)
		
	OS.set_window_title("IdleMMO | fps: " + str(Engine.get_frames_per_second()))
