extends HBoxContainer

var item : Item

onready var label_name = $Name
onready var label_value = $Value
onready var text = $TextureRect

var dragging = false
var previous_location
export var slot_size = 32


func _ready():
	label_name.text = item.name
	label_value.text = str(item.calculate_value())
	previous_location = text.rect_global_position
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if (event.position - text.rect_global_position).length() < 32:
			
			if not dragging and event.pressed:
				dragging = true
				
		if dragging and not event.pressed:
			dragging = false
			text.rect_global_position = previous_location
			
			var slots = get_tree().get_nodes_in_group("EquipmentSlot")
			for slot in slots:
				if pos_in_rect(event.position, slot.rect_global_position):
					if slot.slotType == item.equipment_slot:
						print("Equip Item to " + slot.name + "!")	
						
						Global.InspectTarget.equipment.equip(item)
						Global.InspectTarget.items.erase(item)
	
	if event is InputEventMouseMotion and dragging:
		text.rect_global_position = event.position

func pos_in_rect(pos, rect_pos):
	var inside = false
	
	if pos.x >= rect_pos.x && pos.x <= rect_pos.x + slot_size:
		if pos.y >= rect_pos.y && pos.y <= rect_pos.y + slot_size:
			inside = true
			
	return inside
