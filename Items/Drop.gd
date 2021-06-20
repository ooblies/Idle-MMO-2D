extends KinematicBody2D
class_name Drop

var loot
var target

export var move_speed = 100
var wait = true

onready var collision = $CollisionShape2D
onready var sprite = $Sprite


func _process(delta):
	if !wait && target:
		var target_pos = (target.global_position - global_position).normalized()
		
		if (target.has_inventory_space()):
			var _temp = move_and_collide(target_pos * move_speed * delta)

func go():
	collision.disabled = false
	wait = false

func _on_Timer_timeout():
	go()
