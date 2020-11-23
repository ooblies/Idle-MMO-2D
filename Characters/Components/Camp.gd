extends StaticBody2D
class_name Camp

export(int) var heal_strength = 1
export(int) var heal_frequency = 2
export(int) var mana_strength = 1
export(int) var heal_radius = 50
export(bool) var active = true

onready var heal_timer = $Timer
onready var healbox = $Healbox
onready var healbox_collision = $Healbox/CollisionShape2D
onready var collision_shape = $CollisionShape2D
onready var exclamation = $Exclamation

func _ready():
	heal_timer.start(heal_frequency)
	healbox_collision.shape.radius = heal_radius
	healbox_collision.disabled = true
	healbox.damage = heal_strength
	healbox.mana = mana_strength


func _on_Timer_timeout():
	heal_timer.start(heal_frequency)
	if active:
		healbox_collision.disabled = false
		
		yield(get_tree().create_timer(.25), "timeout")
		healbox_collision.disabled = true

func get_target_position():
	var calc_spawn_radius = heal_radius - collision_shape.shape.radius
	
	var spawn_loc = Vector2(rand_range(-calc_spawn_radius, calc_spawn_radius), rand_range(-calc_spawn_radius, calc_spawn_radius))
	if spawn_loc.x > 0:
		spawn_loc.x += collision_shape.shape.radius
	else: 
		spawn_loc.x -= collision_shape.shape.radius
	if spawn_loc.y > 0:
		spawn_loc.y += collision_shape.shape.radius
	else: 
		spawn_loc.y -= collision_shape.shape.radius
	
	return global_position + spawn_loc


func _on_Clickable_click():
	exclamation.visible = false
	Global.InspectTarget = self
