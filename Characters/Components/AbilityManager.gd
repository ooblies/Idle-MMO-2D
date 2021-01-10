extends Node2D

signal add_effect

export(Array, Resource) var abilities = []

var active_ability_1 : Ability setget set_ability1
func set_ability1(id):
	if id != null:
		active_ability_1 = abilities[id]
	else:
		active_ability_1 = null
	#ability_timer_1.start(active_ability_1.cooldown)
	
var active_ability_2 : Ability setget set_ability2
func set_ability2(id):
	if id != null:
		active_ability_2 = abilities[id]
	else:
		active_ability_2 = null
	#ability_timer_2.start(active_ability_2.cooldown)
	
var active_ability_3 : Ability setget set_ability3
func set_ability3(id):
	if id != null:
		active_ability_3 = abilities[id]
	else:
		active_ability_3 = null
	#ability_timer_3.start(active_ability_3.cooldown)

var parent
	
onready var ability_timer_1 = $AbilityTimer1
onready var ability_timer_2 = $AbilityTimer2
onready var ability_timer_3 = $AbilityTimer3
onready var hitbox : Area2D = $HitboxPivot/Hitbox
onready var hitbox_pivot : Position2D = $HitboxPivot
onready var friendly_detector: Area2D = $FriendlyDetector

func _ready():	
	#this order has to match enum in global
	abilities.clear()
	abilities.resize(Global.Abilities.size())
	
	#To-Do: dynamically load
	for a in Global.Abilities.size():
		var name = Global.Abilities.keys()[a]
		abilities[a] = load("res://Abilities/" + name + ".tres")
	#abilities[Global.Abilities.Test_CircleAttack] = preload("res://Abilities/Test_CircleAttack.tres")
	#abilities[Global.Abilities.Test_RectangleAttack] = preload("res://Abilities/Test_RectangleAttack.tres")
	#abilities[Global.Abilities.Warrior_Strengthen] = preload("res://Abilities/Warrior_Strengthen.tres")
	#abilities[Global.Abilities.Warrior_BigAttack] = preload("res://Abilities/Warrior_BigAttack.tres")
	#abilities[Global.Abilities.Warrior_Block] = preload("res://Abilities/Warrior_Block.tres")
	#abilities[Global.Abilities.Priest_Heal] = preload("res://Abilities/Priest_Heal.tres")
	#abilities[Global.Abilities.Priest_Regen] = preload("res://Abilities/Priest_Regen.tres")
	#abilities[Global.Abilities.Priest_Resurrect] = preload("res://Abilities/Priest_Resurrect.tres")
	
	#activate_ability(abilities[Global.Abilities.Priest_Regen])
	
	#add_child(create_particles(abilities[Global.Abilities.Priest_Regen]))
	
	#global_position = parent.global_position
	
	
func get_ability_from_name(name):
	for a in abilities:
		if name in a.resource_path.to_lower():
			return a
	
func activate_buffs():
	if active_ability_1 != null:
		if ability_timer_1.time_left <= 0:
			if active_ability_1.ability_type == Global.AbilityType.Effect \
				&& active_ability_1.effect_frequency == 0 \
				&& (active_ability_1.effect_stat_increase_base > 0 \
					|| active_ability_1.effect_stat_increase_multiplier > 0):
						
				ability_timer_1.start(active_ability_1.cooldown)
				active_ability_1.last_used = OS.get_time()
				return active_ability_1
	if active_ability_2 != null:
		if ability_timer_2.time_left <= 0:
			if active_ability_2.ability_type == Global.AbilityType.Effect \
				&& active_ability_2.effect_frequency == 0 \
				&& (active_ability_2.effect_stat_increase_base > 0 \
					|| active_ability_2.effect_stat_increase_multiplier > 0):
				
				ability_timer_2.start(active_ability_2.cooldown)
				active_ability_2.last_used = OS.get_time()
				return active_ability_2
	if active_ability_3 != null:
		if ability_timer_3.time_left <= 0:
			if active_ability_3.ability_type == Global.AbilityType.Effect \
				&& active_ability_3.effect_frequency == 0 \
				&& (active_ability_3.effect_stat_increase_base > 0 \
					|| active_ability_3.effect_stat_increase_multiplier > 0):
				
				ability_timer_3.start(active_ability_3.cooldown)
				active_ability_3.last_used = OS.get_time()
				return active_ability_3
	return null

func activate_resurrect():
	if active_ability_1 != null:
		if ability_timer_1.time_left <= 0:
			if active_ability_1.ability_type == Global.AbilityType.Resurrect:
				if parent.party != null:
					if parent.party.get_dead_member() != null:
						
						ability_timer_1.start(active_ability_1.cooldown)
						active_ability_1.last_used = OS.get_time()
						return active_ability_1
	if active_ability_2 != null:
		if ability_timer_2.time_left <= 0:
			if active_ability_2.ability_type == Global.AbilityType.Resurrect:
				if parent.party != null:
					if parent.party.get_dead_member() != null:
						
						ability_timer_2.start(active_ability_2.cooldown)
						active_ability_2.last_used = OS.get_time()
						return active_ability_2
	if active_ability_3 != null:
		if ability_timer_3.time_left <= 0:
			if active_ability_3.ability_type == Global.AbilityType.Resurrect:
				if parent.party != null:
					if parent.party.get_dead_member() != null:
						
						ability_timer_3.start(active_ability_3.cooldown)
						active_ability_3.last_used = OS.get_time()
						return active_ability_3
	return null

func activate_ability_1():	
	ability_timer_1.start(active_ability_1.cooldown)
	active_ability_1.last_used = OS.get_time()
	activate_ability(active_ability_1)
func activate_ability_2():	
	ability_timer_2.start(active_ability_2.cooldown)
	active_ability_2.last_used = OS.get_time()
	activate_ability(active_ability_2)
func activate_ability_3():
	ability_timer_3.start(active_ability_3.cooldown)
	active_ability_3.last_used = OS.get_time()
	activate_ability(active_ability_3)
	
func get_ready_ability(current_mana):
	if active_ability_1 != null:
		if ability_timer_1.time_left <= 0 \
			&& current_mana >= active_ability_1.mana_cost:
			
			if active_ability_1.ability_type == Global.AbilityType.Resurrect:
				if parent.party == null:
					return null
				if parent.party.get_dead_member() == null:
					return null
			
			ability_timer_1.start(active_ability_1.cooldown)
			active_ability_1.last_used = OS.get_time()
			return active_ability_1
	
	if active_ability_2 != null:
		if ability_timer_2.time_left <= 0 \
			&& current_mana >= active_ability_2.mana_cost:
				
			if active_ability_2.ability_type == Global.AbilityType.Resurrect:
				if parent.party == null:
					return null
				if parent.party.get_dead_member() == null:
					return null
					
			ability_timer_2.start(active_ability_2.cooldown)
			active_ability_2.last_used = OS.get_time()
			return active_ability_2
			
	if active_ability_3 != null:
		if ability_timer_3.time_left <= 0 \
			&& current_mana >= active_ability_3.mana_cost:
				
			if active_ability_3.ability_type == Global.AbilityType.Resurrect:
				if parent.party == null:
					return null
				if parent.party.get_dead_member() == null:
					return null
					
			ability_timer_3.start(active_ability_3.cooldown)
			active_ability_3.last_used = OS.get_time()
			return active_ability_3
		
	return null
	
func activate_ready_ability():
	if active_ability_1 != null:
		if ability_timer_1.time_left <= 0:
			activate_ability_1()
			return active_ability_1.name
	
	if active_ability_2 != null:
		if ability_timer_2.time_left <= 0:
			activate_ability_2()
			return active_ability_2.name
			
	if active_ability_3 != null:
		if ability_timer_3.time_left <= 0:
			activate_ability_3()
			return active_ability_3.name
		
	return null

func calculate_ability_damage(a: Ability):
	var base = a.base_damage
	var strDmg = a.strength_damange * parent.get_effective_stat(Global.Stats.Strength)
	var intDmg = a.intelligence_damage * parent.get_effective_stat(Global.Stats.Intelligence)
	var agiDmg = a.agility_damage * parent.get_effective_stat(Global.Stats.Agility)
	#var weaponDmg = a.weapon_damage * weapon.damage
	
	return base + strDmg + intDmg + agiDmg # + weaponDmg

func calculate_heal_amount(a : Ability):
	var base = a.base_heal
	var intHeal = a.intelligence_heal * parent.get_effective_stat(Global.Stats.Intelligence)
	
	return base + intHeal
	
func calculate_effect_stat_increase(a : Ability):
	var multi
	match a.effect_stat:
		Global.Stats.Agility:
			multi = parent.stats.Agility * a.effect_stat_increase_multiplier
			if multi > 0:
				multi-= parent.stats.Agility
		Global.Stats.Constitution:
			multi = parent.stats.Constitution * a.effect_stat_increase_multiplier
			if multi > 0:
				multi-= parent.stats.Constitution
		Global.Stats.Intelligence:
			multi = parent.stats.Intelligence * a.effect_stat_increase_multiplier
			if multi > 0:
				multi-= parent.stats.Intelligence
		Global.Stats.Strength:
			multi = parent.stats.Strength * a.effect_stat_increase_multiplier
			if multi > 0:
				multi-= parent.stats.Strength
				
	return multi + a.effect_stat_increase_base


func heal_target(target, amount):	
	#character healbox
	hitbox.set_collision_layer_bit(4, true)
	hitbox.set_collision_mask_bit(2, true) 
	hitbox.heal_amount = amount
	
	var collision = CollisionShape2D.new()	
	collision.global_position = target.global_position
	
	var shape = CircleShape2D.new()
	shape.radius = 4
	
	collision.set_shape(shape)
	hitbox.add_child(collision)
	yield(get_tree().create_timer(.1), "timeout")
	collision.queue_free()

func create_particle_effect(a):
	var particles : Particles2D = load("res://Effects/GroundEffect.tscn").instance()
	
	particles.radius = a.ability_radius
	particles.texture = a.ground_effect_texture
	particles.amount = a.ground_effect_amount
	particles.lifetime = a.ground_effect_lifetime
	
	particles.process_material.gravity = a.ground_effect_gravity
	particles.process_material.direction = a.ground_effect_direction
	particles.process_material.initial_velocity = a.ground_effect_initial_velocity
	particles.process_material.linear_accel_curve = a.ground_effect_accel_curve
	
	return particles

func activate_ability(a: Ability):
	print("activating " + a.name)
	
	var collision = CollisionShape2D.new()
	var shape
			
	match a.ability_type:
		Global.AbilityType.Damage:
			var de = damage_event.new()
			de.attacker_level = parent.stats.level
			de.damage = calculate_ability_damage(a)
			de.damage_type = a.damage_type
			
			hitbox.damage_event = de
			
			hitbox.set_collision_mask_bit(12, true) #enemy hurtbox
		
			match a.ability_target_type:
				Global.AbilityTargetType.EnemySingle:
					print("Unhandled Ability Case - de")
					
				Global.AbilityTargetType.Shaped:
								
					match a.ability_shape:
						Global.AbilityShapes.Circle:
							
							shape = CircleShape2D.new()
							shape.radius = a.ability_radius
							
							match a.ability_shape_center:
								Global.AbilityShapeCenter.Self:
									#collision.global_position = parent.global_position
									pass
								Global.AbilityShapeCenter.Target:
									print("Unhandled Ability Case - dsct")
									
						Global.AbilityShapes.Rectangle:							
							shape = RectangleShape2D.new()
							shape.set_extents(a.ability_rectangle_size)
							
							match a.ability_shape_center:
								Global.AbilityShapeCenter.Self:
									#TODO this isn't quite right
									collision.global_position = Vector2(a.ability_rectangle_size.x,a.ability_rectangle_size.y/2*-1)
								Global.AbilityShapeCenter.Target:									
									print("Unhandled Ability Case - dsrt")
									
				Global.AbilityTargetType.FriendlyLowest:
					print("Unhandled Ability Case - dl")
					
				Global.AbilityTargetType.FriendlyAll:
					print("Unhandled Ability Case - da")
					
			collision.set_shape(shape)
			hitbox.add_child(collision)
			
			if a.projectile_texture != null:
				hitbox_pivot.rotation_degrees = parent.hitbox_pivot.rotation_degrees
				
			yield(get_tree().create_timer(max(.1,a.effect_duration)), "timeout")
			collision.queue_free()


		Global.AbilityType.Heal:
			var heal_amount = calculate_heal_amount(a)
			match a.ability_target_type:
				Global.AbilityTargetType.Shaped:
					match a.ability_shape:
						Global.AbilityShapes.Circle:
							#create area
							var heal_area = load("res://Hitboxes & Hurtboxes/Hitbox.tscn").instance()
							heal_area.set_collision_layer_bit(4, true)
							heal_area.set_collision_mask_bit(2, true) 
							heal_area.heal_amount = heal_amount
							
							#collision.global_position = parent.global_position
							
							shape = CircleShape2D.new()
							shape.radius = a.ability_radius
							
							collision.set_shape(shape)
							collision.disabled = true
							heal_area.add_child(collision)
							heal_area.blink_shape = collision
							
							#create timer for area
							var timer = Timer.new()
							timer.wait_time = a.effect_frequency
							timer.autostart = true
							heal_area.add_child(timer)
							timer.connect("timeout", heal_area,"blink")
							
							#add particles
							var particles = create_particle_effect(a)
							#particles.position = parent.global_position
							heal_area.add_child(particles)
							
							#add area
							add_child(heal_area)
							yield(get_tree().create_timer(a.effect_duration), "timeout")
							heal_area.queue_free()
							
						Global.AbilityShapes.Rectangle:
							match a.ability_shape_center:
								Global.AbilityShapeCenter.Self:
									print("Unhandled Ability Case - hsrc")

				Global.AbilityTargetType.FriendlyLowest:
					#Get friendlies in area (incl. self)
					#To-Do: Check party members instead of area
					var bodies = friendly_detector.get_overlapping_bodies()
					
					var lowest_hp_target = parent
					for body in bodies:
						#find lowest hp
						if body.is_in_group("Characters"):
							if body.stats.health / body.stats.max_health < lowest_hp_target.stats.health / lowest_hp_target.stats.max_health:
								lowest_hp_target = body
						
					#create (tiny) healbox on them
					heal_target(lowest_hp_target, heal_amount)
					
				Global.AbilityTargetType.FriendlyAll:
					var bodies = friendly_detector.get_overlapping_bodies()
					for body in bodies:
						if body.is_in_group("Characters"):
							heal_target(body, heal_amount)
					heal_target(parent, heal_amount)
					
				Global.AbilityTargetType.Self:
					heal_target(parent, heal_amount)


		Global.AbilityType.Effect:
			match a.ability_target_type:
				#DoTs
				
				Global.AbilityTargetType.EnemySingle:
						print("Unhandled Ability Case - ee")
						
				Global.AbilityTargetType.Shaped:
					var dmg_area = load("res://Hitboxes & Hurtboxes/Hitbox.tscn").instance()
					
					var de = damage_event.new()
					de.attacker_level = parent.stats.level
					de.damage = calculate_ability_damage(a)
					de.damage_type = a.damage_type
					dmg_area.damage_event = de
					
					dmg_area.set_collision_mask_bit(12, true) #enemy hurtbox
					
					match a.ability_shape:
						Global.AbilityShapes.Circle:
							shape = CircleShape2D.new()
							shape.radius = a.ability_radius
							
							match a.ability_shape_center:
								Global.AbilityShapeCenter.Self:
									#collision.global_position = parent.global_position
									pass
								Global.AbilityShapeCenter.Target:
									var pos = parent.get_enemy_position()
									if pos != null: 
										pos = pos + Vector2(global_position.x * -1, global_position.y * -1)
									else:
										pos = Vector2.ZERO
									collision.global_position = pos
									
						Global.AbilityShapes.Rectangle:
							shape = RectangleShape2D.new()
							shape.set_extents(a.ability_rectangle_size)
							
							match a.ability_shape_center:
								Global.AbilityShapeCenter.Self:
									collision.global_position = Vector2(a.ability_rectangle_size.x,a.ability_rectangle_size.y/2*-1)
								Global.AbilityShapeCenter.Target:
									collision.global_position = parent.get_enemy_position() + Vector2(a.ability_rectangle_size.x,a.ability_rectangle_size.y/2*-1)
					
					#set collision
					
					collision.set_shape(shape)
					collision.disabled = true
					
					if a.projectile_texture != null:
						var pivot = Position2D.new()
						pivot.add_child(collision)
						dmg_area.add_child(pivot)
						pivot.rotation_degrees = parent.hitbox_pivot.rotation_degrees
					else:
						dmg_area.add_child(collision)
					
					dmg_area.blink_shape = collision
					
					#create timer for area
					var timer = Timer.new()
					timer.wait_time = a.effect_frequency
					timer.autostart = true
					dmg_area.add_child(timer)
					timer.connect("timeout", dmg_area,"blink")
					
					#add particles
					var particles = create_particle_effect(a)
					particles.position = collision.global_position + a.ground_effect_position_offset
					dmg_area.add_child(particles)
					
					#add area
					add_child(dmg_area)
					timer.emit_signal("timeout")
					yield(get_tree().create_timer(a.effect_duration), "timeout")
					dmg_area.queue_free()
				
				#buffs
				Global.AbilityTargetType.FriendlyLowest:
					print("Unhandled Ability Case - el")
				Global.AbilityTargetType.FriendlyAll:
					print("Unhandled Ability Case - ea")
				Global.AbilityTargetType.Self:
					if a.effect_frequency == 0:						
						#buff/block
						print("adding effect")
						emit_signal("add_effect",a)


		Global.AbilityType.Resurrect:
			if parent.party == null:
				print("ERROR - AbilityManager.gd - No party found for resurrect")
			else:
				var target = parent.party.get_dead_member()
				if target != null:
					target.revive()






