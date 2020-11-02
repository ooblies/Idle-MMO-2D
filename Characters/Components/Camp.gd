extends StaticBody2D

export(int) var heal_strength = 1
export(int) var heal_frequency = 2
export(int) var heal_radius = 50

onready var heal_timer = $Timer
onready var healbox = $Healbox
onready var healbox_collision = $Healbox/CollisionShape2D

func _ready():
	heal_timer.start(heal_frequency)
	healbox_collision.shape.radius = heal_radius
	healbox_collision.disabled = true


func _on_Timer_timeout():
	heal_timer.start(heal_frequency)
	healbox_collision.disabled = false
	
	yield(get_tree().create_timer(.25), "timeout")
	healbox_collision.disabled = true
