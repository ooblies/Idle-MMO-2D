extends Node2D

onready var player = $AnimationPlayer
onready var sprite = $Sprite
onready var pickup_area = $PickupArea

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


func _on_PickupTimer_timeout():
	print("Pulling Items")
	var nearby_characters = pickup_area.get_overlapping_bodies()
	
	for character in nearby_characters:
		var item = character.get_first_depositable_item()
		if item:
			character.inventory.remove(item)
			Global.inventory.append(item)
			print("Pulling - " + str(item.name))
