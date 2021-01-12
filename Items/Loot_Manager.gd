extends Node

var drop_scene = preload("res://Items/Drop.tscn")


var WOODEN_1H_SWORD = preload("res://Items/Resources/Wooden_1h_Sword.tres")


func generate_loot(enemy):
	var loot : Array
	match enemy.enemy_enum:
		Global.Enemies.Mouse:
			if randf() <= .1: #10% chance
				loot.append(generate_item(WOODEN_1H_SWORD))
		Global.Enemies.Bat:
			if randf() <= .3: #30% chance
				loot.append(generate_item(WOODEN_1H_SWORD))
		Global.Enemies.Boar:
			if randf() <= .6: #60% chance
				loot.append(generate_item(WOODEN_1H_SWORD))
	return loot
	

func generate_drop_scene(enemy):
	var loot = generate_loot(enemy)
	
	if loot.empty():
		return null
		
	var new_drop : Drop = drop_scene.instance()
	new_drop.loot = loot
	
	return new_drop

func generate_item(item):
	var i = item.duplicate()
	i.generate()
	i.item_id = i.get_instance_id()
	return i

func get_test_item():
	return generate_item(WOODEN_1H_SWORD)
