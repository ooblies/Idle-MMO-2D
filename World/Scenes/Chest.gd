extends Node2D

onready var player = $AnimationPlayer
onready var sprite = $Sprite

var open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.frame = 0 #start closed

func _input(event):
	if event.get("button_index") != null: 
		if event.button_index == BUTTON_LEFT && event.pressed:			
			var mouse_pos = get_local_mouse_position()
			var zero = Vector2.ZERO
			var dist = zero.distance_to(mouse_pos)
			#print("attempted click - distance - " + str(dist))
			if dist < 16:
				if open:
					player.play("Close")
					Global.InspectTarget = null
					open = !open
				else:
					player.play("Open")
					Global.InspectTarget = self
					open = !open

func add_to_global_inventory(item):
	Global.inventory.append(item)
