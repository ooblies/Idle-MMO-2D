extends Node2D




# Called when the node enters the scene tree for the first time.
func _ready():
	var character = CharacterManager.create_character("Archer")
	add_child(character)
