extends Resource
class_name Item



#item
var item_id : int
export(Texture) var icon
export(String) var name = "Item"
export(String) var description = "Description"
export(int) var junk_value = 0

func calculate_value():
	var stat_value = agility + constitution + intelligence + strength
	stat_value *= 10
	
	var weapon_value = (float(min_damage) + float(max_damage) / 2) * weapon_speed
	weapon_value *= 10
	
	var armor_value = float(armor) / 10
	
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
#magic resist
var magic_resist: int
export(int) var min_magic_resist
export(int) var max_magic_resist


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



#generate

func generate():
	randomize()
	
	if is_equipable:
		if max_strength > 0:
			strength = randi() % max_strength + min_strength
		
		if max_agility > 0:
			agility = randi() % max_agility + min_agility
		
		if max_intelligence > 0:
			intelligence = randi() % max_intelligence + min_intelligence
		
		if max_constitution > 0:
			constitution = randi() % max_constitution + min_constitution
			
		if max_armor > 0:
			armor = randi() % max_armor + min_armor
			
		if is_weapon:
			weapon_speed = stepify(rand_range(min_weapon_speed, max_weapon_speed),0.1)
			min_damage = randi() % max_min_damage + min_min_damage
			max_damage = randi() % max_max_damage + min_max_damage
		

