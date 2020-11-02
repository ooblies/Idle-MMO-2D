extends Node

signal add_effect

export(Array, Resource) var abilities = []

var active_ability_1 : Ability setget set_ability1
func set_ability1(id):
	active_ability_1 = abilities[id]
	#ability_timer_1.start(active_ability_1.cooldown)
	
var active_ability_2 : Ability setget set_ability2
func set_ability2(id):
	active_ability_2 = abilities[id]
	#ability_timer_2.start(active_ability_2.cooldown)
	
var active_ability_3 : Ability setget set_ability3
func set_ability3(id):
	active_ability_3 = abilities[id]
	#ability_timer_3.start(active_ability_3.cooldown)

var parent
	
onready var ability_timer_1 = $AbilityTimer1
onready var ability_timer_2 = $AbilityTimer2
onready var ability_timer_3 = $AbilityTimer3
onready var hitbox : Area2D = $Hitbox

func _ready():	
	#this order has to match enum in global
	abilities.clear()
	abilities.resize(Global.Abilities.size())
	
	#dynamically load
	abilities[Global.Abilities.Test_CircleAttack] = preload("res://Abilities/Test_CircleAttack.tres")
	abilities[Global.Abilities.Test_RectangleAttack] = preload("res://Abilities/Test_RectangleAttack.tres")
	abilities[Global.Abilities.Warrior_Strengthen] = preload("res://Abilities/Warrior_Strengthen.tres")
	
func activate_buffs():
	if active_ability_1 != null:
		if ability_timer_1.time_left <= 0:
			if active_ability_1.ability_type == Global.AbilityType.Effect && active_ability_1.effect_frequency == 0:
				activate_ability_1()
				return active_ability_1.name
	if active_ability_2 != null:
		if ability_timer_2.time_left <= 0:
			if active_ability_2.ability_type == Global.AbilityType.Effect && active_ability_2.effect_frequency == 0:
				activate_ability_2()
				return active_ability_2.name
	if active_ability_3 != null:
		if ability_timer_3.time_left <= 0:
			if active_ability_3.ability_type == Global.AbilityType.Effect && active_ability_3.effect_frequency == 0:
				activate_ability_3()
				return active_ability_3.name
	return null

func activate_ability_1():	
	ability_timer_1.start(active_ability_1.cooldown)
	activate_ability(active_ability_1)
	active_ability_1.last_used = OS.get_time()
func activate_ability_2():	
	ability_timer_2.start(active_ability_2.cooldown)
	activate_ability(active_ability_2)
	active_ability_2.last_used = OS.get_time()
func activate_ability_3():
	ability_timer_3.start(active_ability_3.cooldown)
	activate_ability(active_ability_3)
	active_ability_3.last_used = OS.get_time()
	
func activate_ready_ability():
	if active_ability_1 != null:
		if ability_timer_1.time_left <= 0:
			activate_ability_1()
			return active_ability_1.name
	
	if active_ability_2 != null:
		if ability_timer_2.time_left <= 0:
			ability_timer_2.start(active_ability_2.cooldown)
			activate_ability(active_ability_2)
			active_ability_2.last_used = OS.get_time()
			return active_ability_2.name
			
	if active_ability_3 != null:
		if ability_timer_3.time_left <= 0:
			ability_timer_3.start(active_ability_3.cooldown)
			activate_ability(active_ability_3)
			active_ability_3.last_used = OS.get_time()
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
	var intHeal = a.intelligence_heal
	
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

func activate_ability(a: Ability):
	print("activating " + a.name)
	
	var collision = CollisionShape2D.new()
	var shape
			
	match a.ability_type:
		Global.AbilityType.Damage:
			hitbox.damage = calculate_ability_damage(a)
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
									collision.global_position = parent.global_position
								Global.AbilityShapeCenter.Target:
									print("Unhandled Ability Case - dsct")
									
						Global.AbilityShapes.Rectangle:							
							shape = RectangleShape2D.new()
							shape.set_extents(a.ability_rectangle_size)
							
							match a.ability_shape_center:
								Global.AbilityShapeCenter.Self:
									collision.global_position = parent.global_position + Vector2(a.ability_rectangle_size.x,0)
								Global.AbilityShapeCenter.Target:									
									print("Unhandled Ability Case - dsrt")
									
				Global.AbilityTargetType.FriendlyLowest:
					print("Unhandled Ability Case - dl")
					
				Global.AbilityTargetType.FriendlyAll:
					print("Unhandled Ability Case - da")
					
			collision.set_shape(shape)
			hitbox.add_child(collision)
			yield(get_tree().create_timer(max(.5,a.effect_duration)), "timeout")
			collision.queue_free()
				
				
		Global.AbilityType.Heal:
			hitbox.set_collision_mask_bit(4, true) #character healbox
			hitbox.damage = calculate_heal_amount(a)
			
			match a.ability_target_type:
				Global.AbilityTargetType.FriendlyLowest:
					print("Unhandled Ability Case - hl")
					
				Global.AbilityTargetType.FriendlyAll:
					print("Unhandled Ability Case - ha")
					
				Global.AbilityTargetType.Self:
					print("Unhandled Ability Case - hs")
					
		Global.AbilityType.Effect:
			match a.ability_target_type:
				Global.AbilityTargetType.EnemySingle:
						print("Unhandled Ability Case - ee")
						
				Global.AbilityTargetType.Shaped:
					match a.ability_shape:
						Global.AbilityShapes.Circle:
							match a.ability_shape_center:
								Global.AbilityShapeCenter.Self:
									print("Unhandled Ability Case - escs")
								Global.AbilityShapeCenter.Target:
									print("Unhandled Ability Case - esct")
									
						Global.AbilityShapes.Rectangle:
							match a.ability_shape_center:
								Global.AbilityShapeCenter.Self:
									print("Unhandled Ability Case - esrs")
								Global.AbilityShapeCenter.Target:
									print("Unhandled Ability Case - esrt")
									
				Global.AbilityTargetType.FriendlyLowest:
					print("Unhandled Ability Case - el")
				Global.AbilityTargetType.FriendlyAll:
					print("Unhandled Ability Case - ea")
				Global.AbilityTargetType.Self:
					if a.effect_frequency == 0:
						#buff
						print("adding effect")
						emit_signal("add_effect",a)
					else:
						#HoT
						print("Unhandled Ability Case - es")







