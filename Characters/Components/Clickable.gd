extends Area2D

signal inspect_target(target)

func _ready():
	
	var world = get_tree().get_root().get_node("World")
	var _cnct = connect("inspect_target", world ,"_on_inspect_target")

func _input_event(_viewport, event, _shape_idx):
	if event.get("button_index") != null:
		if event.button_index == BUTTON_LEFT && event.pressed:
			
			emit_signal("inspect_target",get_owner())
			
