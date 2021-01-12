extends Control

var item : Item

onready var container = $HBoxContainer
onready var label_name = $HBoxContainer/Name
onready var label_value = $HBoxContainer/Value
onready var text = $HBoxContainer/TextureRect
onready var upgrade = $HBoxContainer/Upgrade

var dragging = false
var previous_location
export var slot_size = 32


func _ready():
	label_name.text = item.name
	label_value.text = str(item.calculate_value())
	refresh()

func _input(event):
	#click
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		#if (event.position - text.rect_global_position).length() < slot_size:
		if pos_in_rect(event.position, container.rect_global_position, container.rect_size):
			
			#grab
			if not dragging and event.pressed:
				dragging = true
				previous_location = text.rect_global_position
		
		#release
		if dragging and not event.pressed:
			dragging = false
			
			var slots = get_tree().get_nodes_in_group("EquipmentSlot")
			for slot in slots:
				#equip
				if pos_in_rect(event.position, slot.rect_global_position, Vector2(slot_size,slot_size)):
					if slot.slotType == item.equipment_slot:
						
						var unequipped_items = Global.InspectTarget.equipment.equip(item)
						for unequipped_item in unequipped_items:
							Global.InspectTarget.inventory.add(unequipped_item)
						Global.InspectTarget.inventory.remove(item)
				else:
					text.rect_global_position = previous_location
	#drag
	if event is InputEventMouseMotion:
		if dragging:
			text.rect_global_position = event.position
	
	

func refresh():
	if Global.InspectTarget.is_in_group("Characters"):
		if Global.InspectTarget.equipment.get_equipment_by_slot(item.equipment_slot) != null:
			if item.calculate_value() > Global.InspectTarget.equipment.get_equipment_by_slot(item.equipment_slot).calculate_value():
				upgrade.visible = true
			else:
				upgrade.visible = false
		else:
			upgrade.visible = true


func pos_in_rect(pos, rect_pos, rect_size : Vector2):
	var inside = false
	
	if pos.x >= rect_pos.x && pos.x <= rect_pos.x + rect_size.x:
		if pos.y >= rect_pos.y && pos.y <= rect_pos.y + rect_size.y:
			inside = true
			
	return inside
