extends Area2D

var damage_event : damage_event
var heal_amount = 0
var blink_shape

func blink():
	blink_shape.disabled = false
	yield(get_tree().create_timer(.1), "timeout")
	blink_shape.disabled = true
