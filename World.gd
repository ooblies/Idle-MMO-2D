extends Node2D

onready var navigation_line = $Line2D

onready var inspect_ui = $UI/InspectUI
onready var camera = $Camera2D
onready var character_sort = $YSort/Characters



func _on_inspect_target(target):
	inspect_ui.inspect_target = target
	camera.inspect(target)

func _cancel_inspect():
	inspect_ui.inspect_target = null



func _on_Button_button_down(): # Spawn button
	print("Spawn Warrior")
	var warrior = CharacterManager.create_character(Global.Classes.Warrior)
	character_sort.add_child(warrior)
	warrior.set_global_position(Vector2(64,64))
	
	print("Spawn Archer")
	var archer = CharacterManager.create_character(Global.Classes.Archer)
	character_sort.add_child(archer)
	archer.set_global_position(Vector2(128,128))
	
