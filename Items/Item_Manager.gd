extends Node

var drop_scene = preload("res://Items/Drop.tscn")

func _ready():
	pass # Replace with function body.

func generate_drop_scene():
	var new_drop : Drop = drop_scene.instance()
	var new_item = generate_item()
	new_drop.item = new_item
	new_drop.icon = new_item.icon
	
	return new_drop

func generate_item():
	randomize()
	var new_item : Item = load("res://Items/Wooden_1h_Sword.tres").duplicate()
	new_item.item_id = new_item.get_instance_id()
	
	if new_item.is_equipable:
		if new_item.max_strength > 0:
			new_item.strength = randi() % new_item.max_strength + new_item.min_strength
		
		if new_item.max_agility > 0:
			new_item.agility = randi() % new_item.max_agility + new_item.min_agility
		
		if new_item.max_intelligence > 0:
			new_item.intelligence = randi() % new_item.max_intelligence + new_item.min_intelligence
		
		if new_item.max_constitution > 0:
			new_item.constitution = randi() % new_item.max_constitution + new_item.min_constitution
			
		if new_item.max_armor > 0:
			new_item.armor = randi() % new_item.min_armor + new_item.max_armor
			
		if new_item.is_weapon:
			new_item.weapon_speed = stepify(rand_range(new_item.min_weapon_speed, new_item.max_weapon_speed),0.1)
			new_item.min_damage = randi() % new_item.max_min_damage + new_item.min_min_damage
			new_item.max_damage = randi() % new_item.max_max_damage + new_item.min_max_damage
		
	return new_item
	
	
