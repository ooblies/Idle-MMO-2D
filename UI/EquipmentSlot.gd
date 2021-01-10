extends Control

export(Global.EquipmentSlot) var slotType = Global.EquipmentSlot.None
export(bool) var can_accept = true

onready var default = $ReferenceRect/DefaultImage
onready var image = $ReferenceRect/EquipmentImage


func _ready():
	set_default_image()
	default.visible = true
	image.visible = false
	
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed and image.visible:
		if (event.position - image.rect_global_position).length() < 32:
			var unequipped_item = Global.InspectTarget.equipment.unequip_slot(slotType)
			if unequipped_item:
				Global.InspectTarget.inventory.add(unequipped_item)

func set_default_image():
	var slotName = Global.EquipmentSlot.keys()[slotType].to_lower()
	
	var textureName = "res://Items/Equipment/Icons/" + slotName + ".png"
	
	default.texture = load(textureName)
	default.modulate = Color(0.1,0.1,0.1,.5)
	
func _process(_delta):
	if Global.InspectTarget != null:
		if Global.InspectTarget.is_in_group("Characters"):
			var equip = Global.InspectTarget.equipment.get_equipment_by_slot(slotType)
			
			if equip != null:
				image.texture = equip.icon
				image.visible = true
				default.visible = false
			else:
				image.visible = false
				default.visible = true
