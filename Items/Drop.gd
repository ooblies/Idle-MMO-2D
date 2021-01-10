extends KinematicBody2D
class_name Drop

var loot
var target_character

export var move_speed = 100
var wait = true

onready var collision = $CollisionShape2D


func _process(delta):
	if !wait:
		var target = (target_character.global_position - global_position).normalized()
		
		var _temp = move_and_collide(target * move_speed * delta)

func _on_Timer_timeout():
	collision.disabled = false
	wait = false
	