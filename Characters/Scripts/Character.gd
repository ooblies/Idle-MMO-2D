extends KinematicBody2D
class_name Character

#signal update_state(value)
#signal update_health(value)


#Onready vars
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var hitbox_pivot  = $HitboxPivot
onready var hitbox : Area2D = $HitboxPivot/Hitbox
onready var hitbox_area_shape : CollisionShape2D = $HitboxPivot/Hitbox/CollisionShape2D
onready var attack_area : Area2D = $HitboxPivot/AttackArea
onready var attack_area_shape : CollisionShape2D = $HitboxPivot/AttackArea/CollisionShape2D
onready var attack_timer : Timer = $AttackTimer
onready var health_ui = $HealthUI
onready var stats = $Stats
onready var hurt_box : Area2D = $Hurtbox
onready var sprite : Sprite = $Sprite
onready var ability_manager = $AbilityManager
onready var navigation = get_node("/root/World/Navigation")
#onready var navigation_line = get_owner().get_node("Line2D")
onready var navigation_line : Line2D = $NavigationLine
onready var effect_manager = $EffectManager
onready var respawn_timer : Timer = $RespawnTimer
onready var respawn_point = $RespawnPoint
onready var soft_collisions = $SoftCollision
onready var nametag : Label = $NameTag
onready var clickable = $Clickable
onready var exclamation = $Exclamation

#physics vars
export var acceleration = 300
export var max_speed = 50
export var friction = 200
export var rest_threshhold = .25
export var soft_collision_strength = 400
var velocity = Vector2.ZERO

#navigations vars
var path = null
var paths_hit = 0
var paths_hit_recalculate = 5
var path_radius = 8
export(bool) var draw_path = false

#character vars
var character_name = ""
#class vars
var character_class : CharacterClass

#ability vars
var is_busy = false
var is_dead = false
var ability_to_activate = null
export var respawn_time = 10

#party vars
var party : Party = null

#state and tasks
var state = Global.CharacterStates.Idle
var task = Global.CharacterTasks.Rest
var current_enemy = null
var current_enemy_type = null

#item vars
var inventory : Inventory = load("res://Items/Inventory/Inventory.gd").new()
var equipment : Equipment = load("res://Items/Equipment/Equipment.gd").new()

#config
var config : CharacterConfig = load("res://Characters/Scripts/CharacterConfig.gd").new()
	
export(bool) var in_cave = true

func _ready():
	if character_class == null:
		character_class = load("res://Characters/Components/Classes/Archer.tres")
		
	stats.character_class = character_class
	stats.health = stats.max_health
	stats.experience = 1
	attack_timer.start(stats.attack_speed)
	
	health_ui.max_hearts = stats.max_health
	health_ui.hearts = stats.max_health
	health_ui.experience = stats.experience
	health_ui.max_mana = stats.max_mana
	health_ui.mana = stats.mana
	
	ability_manager.parent = self
	
	respawn_point.position = global_position	
	
	hitbox_area_shape.shape = CapsuleShape2D.new()
	hitbox_area_shape.shape.height = stats.attack_range
	hitbox_area_shape.position.x = stats.attack_range / 2 + 8
	hitbox_area_shape.rotation_degrees = 90
	hitbox_area_shape.disabled = true

	attack_area_shape.shape = CapsuleShape2D.new()
	attack_area_shape.shape.radius = hitbox_area_shape.shape.radius
	attack_area_shape.shape.height = stats.attack_range * 0.9
	attack_area_shape.position = hitbox_area_shape.position	
	hitbox_area_shape.rotation_degrees = 90
	
	#shaders
	var dupe_mat = get_node("Sprite").material.duplicate()
	sprite.material = dupe_mat
	
	
	inventory.add(LootManager.get_test_item())
	#get_cave_path()
	
	var message = character_name + " is ready!"
	EventManager.send_message(message, EventManager.EventType.Info)
	
	
	
	
func get_cave_path():
	return
	var cave = get_parent().get_parent().get_parent()
	navigation = get_node("/root/World/Navigation")
	var target_pos = cave.tilemap.get_exploration_target(position)
	print("Current Pos - " + str(position))
	print("Target Pos - " +  str(target_pos))
	if target_pos != null:
		print("Cave Target Found")
		path = navigation.calculate_path(position, target_pos)
		set_state(Global.CharacterStates.Move)
	else:
		print("No Cave Target Found")
	
func _physics_process(delta):
	nametag.text = character_name
	#print(class_prefix + "- Range:" + str(hitbox_area_shape.shape.height))
	match state:
		Global.CharacterStates.Idle:
			state_idle(delta)
		Global.CharacterStates.Attack:
			state_attack(delta)
		Global.CharacterStates.Move:
			state_move(delta)
				
	if soft_collisions.is_colliding():
		velocity += soft_collisions.get_push_vector() * delta * soft_collision_strength
	velocity = move_and_slide(velocity)
	
	$Leader.visible = false
	if party != null:
		if party.is_party_leader(self):
			$Leader.visible = true
		


func flip_sprite():
	if velocity.normalized().x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true




func get_first_depositable_item():
	for item in inventory.items:
		if item.is_weapon && config.auto_deposit_weapons:
			return item
		if item.is_armor && config.auto_deposit_armor:
			return item
		if item.is_junk && config.auto_deposit_junk:
			return item
			
	return null
	
func res_team():
	if party != null:
		if party.get_dead_member() != null:
			if attack_timer.time_left == 0:
				var res = ability_manager.activate_resurrect()
				if res != null:
					play_animation(res.name.to_lower())
					velocity = Vector2.ZERO
					is_busy = true
					ability_to_activate = res

func state_idle(_delta):
	res_team()
	
	if !is_busy:
		path = null
		play_animation("idle")
		velocity = Vector2.ZERO
		
	
		match task:
			Global.CharacterTasks.Rest:
				seek_closest_camp()
			Global.CharacterTasks.Hunt:		
				#var hpercent = float(stats.health) / float(stats.max_health)	
				#if hpercent < rest_threshhold:
					#camp = seek_closest_camp()
					#if camp:
						#if party != null:
							#party.set_state(Global.CharacterStates.Rest)
						#else:
							#set_state(Global.CharacterStates.Rest)
					#else:
						#seek_enemy()
				#else:
					#seek_enemy()
				seek_enemy()
			Global.CharacterTasks.Fight:
				seek_enemy()
			Global.CharacterTasks.Search:
				seek_enemy()
				
		
		
func seek_closest_camp():
	var camps = get_tree().get_nodes_in_group("Camps")
	var closest_camp = null
	if camps.size() > 0:
		closest_camp = camps[0]
		for camp  in camps:
			if global_position.distance_to(camp.global_position) < global_position.distance_to(closest_camp.global_position):
				closest_camp = camp
	if closest_camp != null:
		var target_position = closest_camp.get_target_position()
		
		if global_position.distance_to(closest_camp.global_position) > 50:
			path = navigation.calculate_path(global_position, target_position)		
			set_state(Global.CharacterStates.Move)
	else:
		#print("no camp found")
		pass
	
func state_attack(_delta):
	if is_busy == false:
		velocity = Vector2.ZERO
		
		if current_enemy != null:
			if attack_timer.time_left == 0:
				#check ability manage timer
				#var ability_activated = ability_manager.activate_ready_ability()
				var ability_activated = ability_manager.get_ready_ability(stats.mana)
				if ability_activated != null:
					play_animation(ability_activated.name.to_lower())
					ability_to_activate = ability_activated
					is_busy = true
				else:
					var de = damage_event.new()
					de.attacker_level = stats.level
					var atk = equipment.calculate_attack()
					var es = get_effective_stat(Global.Stats.Strength)
					de.damage = atk + es
					de.damage_type = Global.DamageTypes.Melee
					
					hitbox.damage_event = de
					
					play_animation("attack_right")
					is_busy = true
				var class_speed = stats.attack_speed
				var weapon_speed = equipment.get_weapon_speed()
				
				attack_timer.start(min(class_speed, weapon_speed))
			else:
				if not attack_area.overlaps_body(current_enemy):
					set_state(Global.CharacterStates.Move)
		else:
			set_state(Global.CharacterStates.Idle)
			

func activate_ability():
	stats.mana -= ability_to_activate.mana_cost
	health_ui.mana = stats.mana
	ability_manager.activate_ability(ability_to_activate)
	
	ability_to_activate = null

func attack_animation_finished():
	is_busy = false
	play_animation("idle")

func state_move(delta):
	res_team()
	if !is_busy:
		#chasing
		if current_enemy:
			#rotate towards enemyh
			var angle = rad2deg(get_angle_to(current_enemy.global_position))
			hitbox_pivot.rotation_degrees = angle
			
			#if in attack range		
			if attack_area.overlaps_body(current_enemy):
				play_animation("idle")
				set_state(Global.CharacterStates.Attack)
			else:
				if path != null:
					var buff = ability_manager.activate_buffs()
					if buff != null:
						play_animation(buff.name.to_lower())
						velocity = Vector2.ZERO
						is_busy = true
						ability_to_activate = buff
					else:
						move_along_path(delta)	
				else :
					set_state(Global.CharacterStates.Idle)
		#travelling
		elif path != null && path.size() > 0:	
			move_along_path(delta)
		else:		
			#CaveTest
			if in_cave:
				get_cave_path()
			else:
				set_state(Global.CharacterStates.Idle)


func update_navigation_line():	
	if draw_path && path.size() > 0:
		var pos = global_position
		var line_points = [Vector2(0,0)]
				
		for point in path:
			line_points.append(point - pos)
		
		navigation_line.points = line_points
		
func move_along_path(delta):
	play_animation("move")
	
	if path == null || path.size() == 0:
		print("No path")
		return
		
	if (global_position.distance_to(path[0]) < path_radius):
		path.remove(0)
		update_navigation_line()
		paths_hit += 1
		
	if paths_hit >= paths_hit_recalculate:
		paths_hit = 0
		if state == Global.CharacterStates.Attack:
			seek_enemy()
		
	if path == null || path.size() == 0:
		path = null
	else :
		var dir = global_position.direction_to(path[0])
		velocity = velocity.move_toward(dir * max_speed, acceleration * delta)
	
		flip_sprite()

func move_to_enemy(e):
	path = navigation.calculate_path(global_position, e.global_position)
	if path != null && path.size() > 0:
		update_navigation_line()
		set_state(Global.CharacterStates.Move)
	else:
		print("can't find a path to " + e.name)
		find_enemy()

func find_enemy():
	#TODO
	pass

func seek_enemy():
	if current_enemy && navigation:
		if party != null:
			if party.is_party_leader(self):
				party.set_attack_target(current_enemy)
			else: 
				move_to_enemy(current_enemy)
		else:
			move_to_enemy(current_enemy)
	else:
		if task == Global.CharacterTasks.Hunt || task == Global.CharacterTasks.Fight:
			if current_enemy:
				path = navigation.calculate_path(global_position, current_enemy.global_position)
				set_state(Global.CharacterStates.Move)
			elif current_enemy_type != null:
				hunt(current_enemy_type)
			
			
		elif task == Global.CharacterTasks.Rest:
			seek_closest_camp()
		#can't find enemy - go to spawner

func hunt(enemy_type):
	current_enemy_type = enemy_type
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		if enemy.enemy_class.enemy_enum == enemy_type:
			current_enemy = enemy
			break
	if task == Global.CharacterTasks.Hunt || task == Global.CharacterTasks.Fight:
		if current_enemy:
			path = navigation.calculate_path(global_position, current_enemy.global_position)
			set_state(Global.CharacterStates.Move)

func _on_Hurtbox_area_entered(area : Area2D):
	#take damage
	if area.collision_layer == 8192: #EnemyHitbox
		if area.damage_event:
			#incoming damage
			var damage = float(area.damage_event.damage)
			
			#armor mitigation
			if area.damage_event.damage_type == Global.DamageTypes.Melee:
				var armor = equipment.get_armor_value()
				var armor_dr = float(armor) / float(armor + 400 + (50 * area.damage_event.attacker_level))
				damage = float(damage * float(1 - armor_dr))
			
			#magic resist mitigation
			if area.damage_event.damage_type == Global.DamageTypes.Magic:
				var mr = equipment.get_magic_resist()
				var mr_dr = float(mr) / float(mr + 400 + (50 * area.damage_event.attacker_level))
				damage = float(damage * float(1 - mr_dr))
				
			#mitigated damage
			var damage_mitigated = effect_manager.get_damage_after_block(damage)
			
			stats.health -= damage_mitigated
			health_ui.hearts = stats.health
	
			hurt_box.create_hit_effect()
			
			if state == Global.CharacterStates.Move || state == Global.CharacterStates.Idle:
				set_state(Global.CharacterStates.Attack)
				seek_enemy()
			
			EventManager.send_message(character_name + " takes " + str(damage_mitigated) + " damage.", EventManager.EventType.Combat)
	
	#recieve healing
	if area.collision_layer == 16: #CharacterHealbox
		stats.health += area.heal_amount
		health_ui.hearts = stats.health
		if (area.get("mana") != null):
			stats.mana += area.mana_regen
			health_ui.mana = stats.mana
		#inspect_ui.stats = stats
		EventManager.send_message(character_name + " heals for  " + str(area.heal_amount) + ".", EventManager.EventType.Combat)

func _on_Stats_no_health():
	die()
	is_busy = true
	respawn_timer.start(respawn_time)

func set_state(new_state):
	state = new_state
	#inspect_ui.status = new_state_text
	print(character_name + " - State:" + Global.CharacterStates.keys()[new_state])

func play_animation(name):
	var animation_name = character_class.class_prefix + name
	
	if animation_player.has_animation(animation_name):
		animation_player.play(animation_name)
	elif animation_player.has_animation("default_" + name):
		animation_player.play("default_" + name)
	else:
		animation_player.play("default_ability")


func _on_stats_changed():
	if stats != null:
		#inspect_ui.stats = stats
		pass


func _on_EnemyDetector_body_exited(body):
	if body.is_in_group("Enemies"):
		if body.enemy_class != null && body.stats.health <= 0:
			stats.experience += body.enemy_class.exp_on_kill 
			health_ui.experience = stats.experience
		
func _add_effect(ability : Ability):
	effect_manager.add_effect(ability)

func get_effective_stat(stat):
	var base = 0
	match stat:		
		Global.Stats.Constitution:
			base = stats.constitution
		Global.Stats.Agility:
			base = stats.agility
		Global.Stats.Strength:
			base = stats.strength
		Global.Stats.Intelligence:
			base = stats.intelligence
			
	var increase = effect_manager.get_stat_buff(stat, stats)
	
	return base + increase

func die():
	velocity = Vector2.ZERO
	sprite.material.shader = load("res://Effects/Ghost.shader")
	play_animation("idle")
	health_ui.visible = false
	hurt_box.monitorable = false
	$CollisionShape2D.disabled = true
	is_dead = true
	
	EventManager.send_message(character_name + " has died. :(", EventManager.EventType.Combat)

func revive():
	set_state(Global.CharacterStates.Idle)
	
	is_busy = false
	is_dead = false
	
	stats.health = stats.max_health
	health_ui.hearts = stats.health
	
	sprite.material.shader = null
	health_ui.visible = true
	hurt_box.monitorable = true
	$CollisionShape2D.disabled = false
	
	global_position = respawn_point.position
	
	respawn_timer.stop()
	EventManager.send_message(character_name + " came back to life :)", EventManager.EventType.Combat)
	
func _on_RespawnTimer_timeout():
	if party != null:
		if party.has_res():
			respawn_timer.start(1)
		else:
			revive()
	else:
		revive()
	

func _on_Clickable_click():	
	Global.InspectTarget = self
	exclamation.visible = false
	
		

func fire_attack_projectile():
	if character_class.attack_projectile_texture != null:
		var projectile : Projectile = load("res://Abilities/Projectiles/Projectile.tscn").instance()
		projectile.texture = character_class.attack_projectile_texture
		projectile.speed = character_class.attack_projectile_speed
		projectile.duration = character_class.attack_projectile_duration
		projectile.offset = character_class.attack_projectile_offset
		projectile.p_rotation = hitbox_pivot.rotation_degrees
		add_child(projectile)
		
func fire_ability_projectile(a_name):
	var a : Ability = ability_manager.get_ability_from_name(a_name)
	if a.projectile_texture != null:
		var projectile : Projectile = load("res://Abilities/Projectiles/Projectile.tscn").instance()
		projectile.texture = a.projectile_texture
		projectile.speed = a.projectile_speed
		projectile.duration = a.projectile_duration
		projectile.offset = a.projectile_offset
		projectile.p_rotation = hitbox_pivot.rotation_degrees
		add_child(projectile)

func has_inventory_space():
	return inventory.has_space();
	
func _on_PickupArea_body_entered(body):
	#TODO print no room message
	if body.target == self && inventory.has_space():
		for item in body.loot:
			inventory.add(item)
			EventManager.send_message(character_name + " picked up " + item.name + ".", EventManager.EventType.Info)
		
		body.queue_free()




#func _on_CaveTimer_timeout():
	#print("Getting Cave Path")
	#get_cave_path()
