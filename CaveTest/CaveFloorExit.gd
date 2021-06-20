extends Node2D

onready var tilemap = get_parent().get_node("Cave")
onready var fog = get_parent().get_node("Fog")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	print("Going down 1 floor")
	if body.is_in_group("Characters"):
		fog.fill_fog()
		tilemap.generate()
