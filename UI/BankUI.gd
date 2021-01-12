extends Control

onready var container = $Panel/ScrollContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func _process(_delta):
	var git = Global.InspectTarget
	
	if git != null:
		if git.is_in_group("Banks"):
			if !visible:
				init()
				visible = true
			display_bank_screen()
		else:
			visible = false
	else:
		visible = false

func init():
	for node in container.get_children():
		node.queue_free()
	
	for item in Global.inventory:
		var new_item_row = load("res://UI/ItemRow.tscn").instance()
		new_item_row.item = item
		
		container.add_child(new_item_row)

func display_bank_screen():
	pass
		
