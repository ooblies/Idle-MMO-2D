extends Area2D

var damage = 1
var blink_shape

func blink():
	blink_shape.disabled = false
	yield(get_tree().create_timer(.1), "timeout")
	blink_shape.disabled = true
