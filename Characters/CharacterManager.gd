extends Node

var character_scene = preload("res://Characters/Scenes/Character.tscn")

func create_character(character_class):
	var character_instance : Character = character_scene.instance()
	
	match character_class:
		Global.Classes.Warrior:
			character_instance.attack_range = 16
			character_instance.character_class = Global.Classes.Warrior
			pass
		Global.Classes.Archer:
			character_instance.attack_range = 64
			character_instance.character_class = Global.Classes.Archer
			pass	
	
	return character_instance
	
