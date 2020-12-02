extends Node

func create_character(character_class):
	var class_resource : CharacterClass = load("res://Characters/Components/Classes/" + character_class + ".tres")
	var character_scene = load("res://Characters/Scenes/Character.tscn")
	var character_instance : Character = character_scene.instance()
	var character_name = Global.get_random_name()
	
	character_instance.character_class = class_resource
	character_instance.character_name = character_name
	
	return character_instance
	
