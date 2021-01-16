extends Node2D

onready var player = $AnimationPlayer
onready var sprite = $Sprite
onready var pickup_area = $PickupArea
onready var pull_area = $PullArea

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


func _on_PullTimer_timeout():
	print("Pulling Items")
	var nearby_characters = pull_area.get_overlapping_bodies()
	
	for character in nearby_characters:
		var item = character.get_first_depositable_item()
		if item:
			character.inventory.remove(item)
			
			print("Pulling - " + str(item.name))
			
			var drop = LootManager.create_drop_with_item(item)
			get_parent().add_child(drop)
			drop.global_position = character.global_position
			drop.target = self			
			drop.sprite.texture = item.icon
			drop.go()


func _on_Area2D_body_entered(body):
	body.queue_free()
	Global.inventory.append(body.loot[0])
	player.play("Close")

