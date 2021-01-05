extends Node
class_name Equipment

var head : Item = null
var chest : Item = null
var legs : Item = null
var hands : Item = null
var feet : Item = null
var neck : Item = null
var finger : Item = null
var main_hand : Item = null
var off_hand : Item = null

func get_stat_bonus(stat):
	var bonus = 0
	var bonus_agi = 0
	var bonus_con = 0
	var bonus_int = 0
	var bonus_str = 0
	
	if head != null:
		bonus_agi += head.agility
		bonus_con += head.constitution
		bonus_str += head.strength
		bonus_int += head.intelligence
	if chest != null:
		bonus_agi += chest.agility
		bonus_con += chest.constitution
		bonus_str += chest.strength
		bonus_int += chest.intelligence
	if legs != null:
		bonus_agi += legs.agility
		bonus_con += legs.constitution
		bonus_str += legs.strength
		bonus_int += legs.intelligence
	if hands != null:
		bonus_agi += hands.agility
		bonus_con += hands.constitution
		bonus_str += hands.strength
		bonus_int += hands.intelligence
	if feet != null:
		bonus_agi += feet.agility
		bonus_con += feet.constitution
		bonus_str += feet.strength
		bonus_int += feet.intelligence
	if finger != null:
		bonus_agi += finger.agility
		bonus_con += finger.constitution
		bonus_str += finger.strength
		bonus_int += finger.intelligence
	if main_hand != null:
		bonus_agi += main_hand.agility
		bonus_con += main_hand.constitution
		bonus_str += main_hand.strength
		bonus_int += main_hand.intelligence
	if off_hand != null:
		bonus_agi += off_hand.agility
		bonus_con += off_hand.constitution
		bonus_str += off_hand.strength
		bonus_int += off_hand.intelligence
	if neck != null:
		bonus_agi += neck.agility
		bonus_con += neck.constitution
		bonus_str += neck.strength
		bonus_int += neck.intelligence
	
	
	match stat:
		Global.Stats.Agility:
			bonus = bonus_agi
		Global.Stats.Constitution:
			bonus = bonus_con
		Global.Stats.Intelligence:
			bonus = bonus_int
		Global.Stats.Strength:
			bonus = bonus_str
			
	return bonus

func get_avg_damage():
	var dmg = 0
	if main_hand != null:
		dmg = (main_hand.min_damage + main_hand.max_damage) / 2
		
	return dmg

func get_weapon_speed():
	var speed = 0 #get_parent().stats.attack_speed
	
	if main_hand != null:
		speed = main_hand.weapon_speed
		
	return speed

func get_armor_value():
	var armor = 0
	
	if head != null:
		armor += head.armor
	if chest != null:
		armor += chest.armor
	if legs != null:
		armor += legs.armor
	if hands != null:
		armor += hands.armor
	if feet != null:
		armor += feet.armor
	if finger != null:
		armor += finger.armor
	if main_hand != null:
		armor += main_hand.armor
	if off_hand != null:
		armor += off_hand.armor
	if neck != null:
		armor += neck.armor
	
	return armor

func get_equipment_by_slot(slot):
	var item = null
	
	match slot:
		Global.EquipmentSlot.Head:
			item = head
		Global.EquipmentSlot.Chest:
			item = chest
		Global.EquipmentSlot.Legs:
			item = legs
		Global.EquipmentSlot.Hands:
			item = head
		Global.EquipmentSlot.Feet:
			item = feet	
		Global.EquipmentSlot.MainHand:
			item = main_hand
		Global.EquipmentSlot.OffHand:
			item = off_hand
		Global.EquipmentSlot.Neck:
			item = neck
		Global.EquipmentSlot.Finger:
			item = finger
			
	return item

func unequip_item(item : Item):
	var unequiped_item : Item = null
	
	if head.item_id == item.item_id:
		unequiped_item = head
		head = null
	if chest.item_id == item.item_id:
		unequiped_item = chest
		chest = null
	if legs.item_id == item.item_id:
		unequiped_item = legs
		legs = null
	if hands.item_id == item.item_id:
		unequiped_item = hands
		hands = null
	if feet.item_id == item.item_id:
		unequiped_item = feet
		feet = null
	if neck.item_id == item.item_id:
		unequiped_item = neck
		neck = null
	if finger.item_id == item.item_id:
		unequiped_item = finger
		finger = null
	if main_hand.item_id == item.item_id:
		unequiped_item = main_hand
		main_hand = null
	if off_hand.item_id == item.item_id:
		unequiped_item = off_hand
		off_hand = null
	
	return unequiped_item

func unequip_slot(slot):
	var unequiped_item : Item = null
	
	match slot:
		Global.EquipmentSlot.Chest:
			unequiped_item = chest
			chest = null
		Global.EquipmentSlot.Feet:
			unequiped_item = feet
			feet = null
		Global.EquipmentSlot.Hands:
			unequiped_item = hands
			hands = null
		Global.EquipmentSlot.Legs:
			unequiped_item = legs
			legs = null
		Global.EquipmentSlot.Neck:
			unequiped_item = neck
			neck = null
		Global.EquipmentSlot.Finger:
			unequiped_item = finger
			finger = null
		Global.EquipmentSlot.MainHand:
			unequiped_item = main_hand
			main_hand = null
		Global.EquipmentSlot.OffHand:
			unequiped_item = off_hand
			off_hand = null
		Global.EquipmentSlot.TwoHand:
			unequiped_item = main_hand
			main_hand = null
	
	return unequiped_item

func equip(item : Item):
	var unequiped_items = []
	
	match item.equipment_slot:
		Global.EquipmentSlot.Chest:
			if chest != null:
				unequiped_items.append(chest)
			chest = item
		Global.EquipmentSlot.Feet:
			if feet != null:
				unequiped_items.append(feet)
			feet = item
		Global.EquipmentSlot.Hands:
			if hands != null:
				unequiped_items.append(hands)
			hands = item
		Global.EquipmentSlot.Legs:
			if legs != null:
				unequiped_items.append(legs)
			legs = item
		Global.EquipmentSlot.Neck:
			if neck != null:
				unequiped_items.append(neck)
			neck = item
		Global.EquipmentSlot.Finger:
			if finger != null:
				unequiped_items.append(finger)
			finger = item
		Global.EquipmentSlot.MainHand:
			if main_hand != null:
				unequiped_items.append(main_hand)
			if item.is_two_hand:
				off_hand = null
				unequiped_items.append(off_hand)
			main_hand = item
		Global.EquipmentSlot.OffHand:
			if off_hand != null:
				unequiped_items.append(off_hand)
			off_hand = item
	
	return unequiped_items
