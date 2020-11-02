extends Area2D

var enemies = null
var enemy = null

func can_see_enemy():
	#if enemy == null:
	enemies = get_overlapping_bodies()
	if enemies.size() > 0:
		enemy = get_closest_enemy()
	
		
	return enemy != null

func get_next_enemy():
	pass

func get_closest_enemy():
	var owner_loc = get_owner().global_position
	var temp_enemy = enemies[0]
	for e in enemies:
		if owner_loc.distance_to(e.global_position) < owner_loc.distance_to(temp_enemy.global_position):
			temp_enemy = e
	return temp_enemy
	

func _on_EnemyDetector_body_entered(body):
	enemies = get_overlapping_bodies()
	if enemy == null:
		enemy = body
	#print(body.name + " entered")

