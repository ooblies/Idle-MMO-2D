extends Node2D

func _ready():
	EventManager.send_message("Game Started", EventManager.EventType.Info)

func _input(event):
	if event.is_action("ui_cancel"):
		Global.InspectTarget = null
		

