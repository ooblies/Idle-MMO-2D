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
export(int) var equipment_tier = 1
export(Global.EquipmentSlot) var equipment_slot = Global.EquipmentSlot.None
export(Global.Classes) var equipment_class = Global.Classes.None

export var stat_preference = ["Agi","Con","Str","Int"]

var agility : int
var constitution : int
var intelligence : int
var strength : int

export(Global.ItemRarity) var rarity
var rarity_multiplier = 1

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
		if randf() > 0.99: #1% chance legendary
			rarity = Global.ItemRarity.Legendary
			rarity_multiplier = 2.5
			print("Generated Legendary Item")
		elif randf() > 0.96: #4% chance epic
			rarity = Global.ItemRarity.Epic
			rarity_multiplier = 2
			print("Generated Epic Item")
		elif randf() > 0.85: #15% chance Rare
			rarity = Global.ItemRarity.Rare
			rarity_multiplier = 1.5
			print("Generated Rare Item")
		elif randf() > 0.7: #30% chance uncommon
			rarity = Global.ItemRarity.Uncommon
			rarity_multiplier = 1.2
			print("Generated Uncommon Item")
		else: # 50% chance
			rarity = Global.ItemRarity.Common
			rarity_multiplier = 1
			print("Generated Common Item")
		
		var stat_pool = int(10 * equipment_tier * rarity_multiplier)
		for stat in stat_preference:
			if stat_pool > 0:
				match stat:
					"Str":
						strength = int(randi() % stat_pool )
						stat_pool = stat_pool - strength
					"Con":
						constitution = int(randi() % stat_pool )
						stat_pool = stat_pool - constitution
					"Agi":
						agility = int(randi() % stat_pool )
						stat_pool = stat_pool - agility
					"Int":
						intelligence = int(randi() % stat_pool )
						stat_pool = stat_pool - intelligence
		
		if max_armor > 0:
			armor = randi() % max_armor + min_armor
			
		if is_weapon:
			weapon_speed = stepify(rand_range(min_weapon_speed, max_weapon_speed),0.1)
			min_damage = randi() % max_min_damage + min_min_damage
			max_damage = randi() % max_max_damage + min_max_damage
		

