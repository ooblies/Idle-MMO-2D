extends Control

export(int) var click_radius = 10

signal click

func _ready():
	pass

func _input(event):
	if event.get("button_index") != null: 
		if event.button_index == BUTTON_LEFT && event.pressed:			
			var mouse_pos = get_local_mouse_position()
			var zero = Vector2.ZERO
			var dist = zero.distance_to(mouse_pos)
			#print("attempted click - distance - " + str(dist))
			if dist < click_radius:
				emit_signal("click")
