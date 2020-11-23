extends Particles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var radius = 64


# Called when the node enters the scene tree for the first time.
func _ready():
	process_material.emission_sphere_radius = radius
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
