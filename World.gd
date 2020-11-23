extends Node2D

func _input(event):
	if event.is_action("ui_cancel"):
		Global.InspectTarget = null
