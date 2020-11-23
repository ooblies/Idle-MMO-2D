extends Node

func create_character(character_class):
	var class_resource : CharacterClass = load("res://Characters/Components/Classes/" + character_class + ".tres")
	var character_scene = load("res://Characters/Scenes/Character.tscn")
	var character_instance : Character = character_scene.instance()
	
	character_instance.character_class = class_resource
	character_instance.character_name = "Test"
	
	#match character_class:
	#	"Warrior":
	#		character_instance.attack_range = 12
	#		character_instance.character_class = Global.Classes.Warrior
	#		character_instance.character_name = "Bobina"
	#	"Archer":
	#		character_instance.attack_range = 64
	#		character_instance.character_class = Global.Classes.Archer
	#		character_instance.character_name = "Jeff"
	#	"Priest":			
	#		character_instance.attack_range = 12
	#		character_instance.character_class = Global.Classes.Priest
	#		character_instance.character_name = "Angelica"
	
	return character_instance
	
