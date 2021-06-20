extends Node

var drop_scene = preload("res://Items/Drop.tscn")

#TODO - do this better
var T1_SWORD = preload("res://Items/Resources/t1_sword.tres")
var T1_LEATHER_BOOTS = preload("res://Items/Resources/t1_leather_boots.tres")
var T1_CLOTH_ARMOR = preload("res://Items/Resources/t1_cloth_armor.tres")
var T1_LEATHER_ARMOR = preload("res://Items/Resources/t1_leather_armor.tres")
var T1_LEATHER_GLOVES = preload("res://Items/Resources/t1_leather_gloves.tres")
var T1_LEATHER_HAT = preload("res://Items/Resources/t1_leather_hat.tres")
var T1_NECKLACE_STRENGTH = preload("res://Items/Resources/t1_necklace_strength.tres")
var T1_NECKLACE_CONSTITUTION = preload("res://Items/Resources/t1_necklace_constitution.tres")
var T1_NECKLACE_AGILITY = preload("res://Items/Resources/t1_necklace_agility.tres")
var T1_NECKLACE_INTELLIGENCE = preload("res://Items/Resources/t1_necklace_intelligence.tres")
var T1_RING_ARMOR = preload("res://Items/Resources/t1_ring_armor.tres")
var T1_RING_RESISTANCE = preload("res://Items/Resources/t1_ring_resist.tres")
var T1_SHIELD = preload("res://Items/Resources/t1_shield.tres")
var T1_SWORD_2H = preload("res://Items/Resources/t1_sword_2h.tres")
var MOUSE_TOOTH = preload("res://Items/Resources/mouse_tooth.tres")



func generate_loot(enemy):
	var loot : Array = []
	match enemy.enemy_enum:
		Global.Enemies.Mouse:
			if randf() <= .7: #70% chance
				loot.append(generate_item(MOUSE_TOOTH))
			if randf() <= .1: #10% chance
				loot.append(generate_item(T1_NECKLACE_STRENGTH))
		Global.Enemies.Bat:
			if randf() <= .3: #30% chance
				loot.append(generate_item(T1_SWORD))
		Global.Enemies.Boar:
			if randf() <= .6: #60% chance
				loot.append(generate_item(T1_SWORD))
	return loot
	

func generate_drop_scene(enemy):
	var loot = generate_loot(enemy)
	
	if loot.empty():
		return null
		
	var new_drop : Drop = drop_scene.instance()
	new_drop.loot = loot
	
	return new_drop


func create_drop_with_item(item):
	var new_drop : Drop = drop_scene.instance()
	var loot : Array = []
	loot.append(item)
	new_drop.loot = loot
	
	return new_drop

func generate_item(item):
	var i = item.duplicate()
	i.generate()
	i.item_id = i.get_instance_id()
	return i

func get_test_item():
	var item
	if randf() > 0.5:
		item = generate_item(T1_SWORD)
	else:
		item = generate_item(T1_LEATHER_BOOTS)
		
	return item
