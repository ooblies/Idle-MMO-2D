extends YSort

export(Global.Enemies) var enemy
export(int) var max_enemies = 1
export(int) var spawn_radius = 100
export(int) var spawn_rate = 1

onready var spawn_area = $SpawnArea
onready var spawn_area_shape = $SpawnArea/CollisionShape2D
onready var timer = $Timer
onready var spawned_enemies = $SpawnedEnemies
onready var collision_shape = $StaticBody2D/CollisionShape2D

var enemy_scene = load("res://Enemies/Scenes/" + Global.Enemies.keys()[enemy] + ".tscn")

onready var navigation = get_owner().get_node("Navigation")


func _ready():
	spawn_area_shape.shape.radius = spawn_radius
	timer.start(spawn_rate)
	print("spawner at - " + str(global_position))
	
	yield(navigation, "ready")
	navigation.disable_point(collision_shape.global_position, collision_shape.shape.radius)

func get_spawn_location():
	
	var calc_spawn_radius = spawn_radius - collision_shape.shape.radius
	
	var spawn_loc = Vector2(rand_range(-calc_spawn_radius, calc_spawn_radius), rand_range(-calc_spawn_radius, calc_spawn_radius))
	if spawn_loc.x > 0:
		spawn_loc.x += collision_shape.shape.radius
	else: 
		spawn_loc.x -= collision_shape.shape.radius
	if spawn_loc.y > 0:
		spawn_loc.y += collision_shape.shape.radius
	else: 
		spawn_loc.y -= collision_shape.shape.radius
	
	return spawn_loc

func _on_Timer_timeout():
	timer.start(spawn_rate)
	var spawned = spawned_enemies.get_child_count()
	if spawned < max_enemies:		
		var spawn_location = get_spawn_location()
		#print(spawn_location)
		var enemy_instance = enemy_scene.instance()
		enemy_instance.set_global_position(spawn_location)
		spawned_enemies.add_child(enemy_instance)	
		
		#print("spawning enemy at - " + str(spawned_enemies.get_child(0).global_position))



