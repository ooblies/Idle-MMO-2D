extends YSort

export(Global.Enemies) var enemy
export(int) var max_enemies = 1
export(int) var spawn_radius = 100
export(int) var spawn_rate = 1
export(bool) var dynamic_max = true

onready var spawn_area = $SpawnArea
onready var spawn_area_shape = $SpawnArea/CollisionShape2D
onready var timer = $Timer
onready var spawned_enemies = $SpawnedEnemies
onready var collision_shape = $StaticBody2D/CollisionShape2D

onready var navigation = get_owner().get_node("Navigation")


func _ready():
	spawn_area_shape.shape.radius = spawn_radius
	timer.start(spawn_rate)
	#print("spawner at - " + str(global_position))
	
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

func get_dynamic_max():
	var dynamic_max = 0
	for body in spawn_area.get_overlapping_bodies():
		if body.is_in_group("Characters"):
			dynamic_max += 1
	if dynamic_max == 0:
		dynamic_max = 1
		
	return dynamic_max

func _on_Timer_timeout():
	timer.start(spawn_rate)
	var spawned = spawned_enemies.get_child_count()
	
	var actual_max = max_enemies
	if dynamic_max:
		actual_max = get_dynamic_max()
	
	if spawned < actual_max:		
		var spawn_location = get_spawn_location()
		#print(spawn_location)
		var enemy_to_spawn = EnemyManager.create_enemy(Global.Enemies.keys()[enemy])
		#enemy_scene = load("res://Enemies/Scenes/" + Global.Enemies.keys()[enemy] + ".tscn")
		#var enemy_instance = enemy_scene.instance()
		enemy_to_spawn.set_global_position(spawn_location)
		spawned_enemies.add_child(enemy_to_spawn)	
		
		#print("spawning enemy at - " + str(spawned_enemies.get_child(0).global_position))



