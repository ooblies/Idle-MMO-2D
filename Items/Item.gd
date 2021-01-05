extends Resource
class_name Item



#item
var item_id : int
export(Texture) var icon
export(String) var name = "Item"
export(int) var junk_value = 0

func calculate_value():
	var stat_value = agility + constitution + intelligence + strength
	stat_value *= 10
	
	var weapon_value = (min_damage + max_damage / 2) * weapon_speed
	weapon_value *= 10
	
	var armor_value = armor / 10
	
	return int(stat_value + weapon_value + armor_value + junk_value)

#consumable
export(bool) var is_consumable = false

#equipment
export(bool) var is_equipable = false
export(Global.EquipmentTier) var equipment_tier = Global.EquipmentTier.None
export(Global.EquipmentSlot) var equipment_slot = Global.EquipmentSlot.None
export(Global.Classes) var equipment_class = Global.Classes.None

var agility : int
export(int) var min_agility = 0
export(int) var max_agility = 0

var constitution : int
export(int) var min_constitution = 0
export(int) var max_constitution = 0

var intelligence : int
export(int) var min_intelligence = 0
export(int) var max_intelligence = 0

var strength : int
export(int) var min_strength = 0
export(int) var max_strength = 0

#armor
export(bool) var is_armor = false
var armor : int
export(int) var min_armor
export(int) var max_armor

#weapon
export(bool) var is_two_hand = false
export(bool) var is_weapon = false
var weapon_speed : float
export(float) var min_weapon_speed = 0.0
export(float) var max_weapon_speed = 0.0
var min_damage : int
export(int) var min_min_damage = 0.0
export(int) var max_min_damage = 0.0
var max_damage  : int
export(int) var min_max_damage = 0.0
export(int) var max_max_damage = 0.0


