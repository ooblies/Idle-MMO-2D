extends KinematicBody2D
class_name Character

#signal update_state(value)
#signal update_health(value)


#Onready vars
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var enemy_detector : Area2D = $EnemyDetector
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
export var rest_threshhold = .5
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
var ability_to_activate = null
export var respawn_time = 10

#party vars
var party : Party = null

#state and tasks
var state = Global.States.Idle

var task = Global.Tasks.Town
var hunting_target = null
var hunting_target_location
	


func _ready():
	#yield(get_owner(), "ready")
	attack_timer.start(stats.attack_speed)
	health_ui.max_hearts = stats.max_health
	health_ui.hearts = stats.max_health
	#health_ui.max_experience = Global.get_experience_at_next_level(stats.experience)
	health_ui.experience = stats.experience
	health_ui.max_mana = stats.max_mana
	health_ui.mana = stats.mana
	
	stats.health = stats.max_health
	ability_manager.parent = self
	stats.character_class = character_class
	

		
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
	
	nametag.text = character_name
	set_state(Global.States.Idle)
	#shaders
	var dupe_mat = get_node("Sprite").material.duplicate()
	sprite.material = dupe_mat
	

func _physics_process(delta):
	#print(class_prefix + "- Range:" + str(hitbox_area_shape.shape.height))
	match state:
		Global.States.Idle:
			state_idle(delta)
		Global.States.Attack:
			state_attack(delta)
		Global.States.Chase:
			state_chase(delta)
		Global.States.Rest:
			state_rest(delta)
		Global.States.Dead:
			state_dead()
		Global.States.Travel:
			state_travel(delta)
				
	if soft_collisions.is_colliding():
		velocity += soft_collisions.get_push_vector() * delta * soft_collision_strength
	velocity = move_and_slide(velocity)


func flip_sprite():
	if velocity.normalized().x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func state_travel(delta):
	res_team()
	if !is_busy:
		if path != null:	
			move_along_path(delta)
		else:		
			match task:
				Global.Tasks.Hunt:
					#set_state(Global.States.Idle)
					if path == null:
						set_state(Global.States.Chase)
					pass
				Global.Tasks.Town:
					play_animation("idle")
					respawn_point.position = global_position
					velocity = Vector2.ZERO				

func state_rest(delta):
	res_team()
	if !is_busy:
		if path != null:	
			move_along_path(delta)
		else:
			if stats.health >= stats.max_health:
				set_state(Global.States.Idle)
			else:
				play_animation("idle")
				velocity = Vector2.ZERO

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
		#if navigation_line != null:
			#navigation_line.points = []
		play_animation("idle")
		velocity = Vector2.ZERO
		
		var camp = false	
	
		match task:
			Global.Tasks.Town:
				camp = seek_closest_camp()
				if camp:
					set_state(Global.States.Travel)
			Global.Tasks.Hunt:		
				var hpercent = float(stats.health) / float(stats.max_health)	
				if hpercent < rest_threshhold:
					camp = seek_closest_camp()
					if camp:
						set_state(Global.States.Rest)
					else:
						seek_enemy()
				else:
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
		#print("Travel to camp - " + str(target_position))
		path = navigation.calculate_path(global_position, target_position)		
		return true
	else:
		#print("no camp found")
		return false
	
func state_attack(_delta):
	if is_busy == false:
		velocity = Vector2.ZERO
		var enemy = enemy_detector.enemy	
		if enemy != null:
			if attack_timer.time_left == 0:
				#check ability manage timer
				#var ability_activated = ability_manager.activate_ready_ability()
				var ability_activated = ability_manager.get_ready_ability(stats.mana)
				if ability_activated != null:
					play_animation(ability_activated.name.to_lower())
					ability_to_activate = ability_activated
					is_busy = true
				else:
					play_animation("attack_right")
					is_busy = true
					
					hitbox.damage = get_effective_stat(Global.Stats.Strength)

				attack_timer.start(stats.attack_speed)
			else:
				if not attack_area.overlaps_body(enemy):
					set_state(Global.States.Chase)
		else:
			set_state(Global.States.Idle)
			

func activate_ability():
	stats.mana -= ability_to_activate.mana_cost
	health_ui.mana = stats.mana
	ability_manager.activate_ability(ability_to_activate)
	
	ability_to_activate = null

func attack_animation_finished():
	is_busy = false
	play_animation("idle")
	
func state_chase(delta):	
	if not is_busy:
		res_team()
		var enemy = enemy_detector.enemy
		if enemy != null:
			var angle = rad2deg(get_angle_to(enemy.global_position))
			hitbox_pivot.rotation_degrees = angle
			
			#if in attack range		
			if attack_area.overlaps_body(enemy):
				play_animation("idle")
				set_state(Global.States.Attack)
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
					set_state(Global.States.Idle)
		else:
			set_state(Global.States.Idle)

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
		return
		
	if (global_position.distance_to(path[0]) < path_radius):
		path.remove(0)
		update_navigation_line()
		paths_hit += 1
		
	if paths_hit >= paths_hit_recalculate:
		paths_hit = 0
		if state == Global.States.Chase:
			seek_enemy()
		
	if path == null || path.size() == 0:
		path = null
	else :
		var dir = global_position.direction_to(path[0])
		velocity = velocity.move_toward(dir * max_speed, acceleration * delta)
	
		flip_sprite()
	
func seek_enemy():
	if enemy_detector.can_see_enemy() && navigation != null:
		path = navigation.calculate_path(global_position, enemy_detector.enemy.global_position)
		if path != null && path.size() > 0:
			update_navigation_line()
			set_state(Global.States.Chase)
		else:
			print("can't find a path to " + enemy_detector.enemy.name)
			enemy_detector.get_next_enemy()
		

func _on_Hurtbox_area_entered(area : Area2D):
	if area.collision_layer == 8192: #EnemyHitbox
		var damage = area.damage
		var damage_mitigated = effect_manager.get_damage_after_block(damage)
		#print("Damage Incoming: " + str(damage))
		#print("Damage Taken:    " + str(damage_mitigated))
		stats.health -= damage_mitigated
		health_ui.hearts = stats.health
		#inspect_ui.stats = stats
	
		hurt_box.create_hit_effect()
		if state == Global.States.Rest || state == Global.States.Travel:
			seek_enemy()
	if area.collision_layer == 16: #CharacterHealbox
		stats.health += area.damage
		health_ui.hearts = stats.health
		if (area.get("mana") != null):
			stats.mana += area.mana
			health_ui.mana = stats.mana
		#inspect_ui.stats = stats

func _on_Stats_no_health():
	#queue_free()
	#var enemy_death_effect_instance = enemy_death_effect.instance()
	#get_parent().add_child(enemy_death_effect_instance)
	#enemy_death_effect_instance.global_position = global_position
	#global_position = respawn_point.position
	#state = Global.States.Dead
	set_state(Global.States.Dead)
	respawn_timer.start(respawn_time)
	#visible = false

func set_state(new_state):
	#var new_state_text = Global.States.keys()[new_state]
	state = new_state
	#inspect_ui.status = new_state_text
	print(character_name + " - State:" + Global.States.keys()[new_state])

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
		if body.stats.level != null:
			stats.experience += body.stats.level
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

func state_dead():
	velocity = Vector2.ZERO
	sprite.material.shader = load("res://Effects/Ghost.shader")
	#sprite.material.shader = load("res://Effects/Ghost.shader")
	play_animation("idle")
	health_ui.visible = false
	hurt_box.monitorable = false
	$CollisionShape2D.disabled = true

func revive():
	set_state(Global.States.Idle)
	
	stats.health = stats.max_health
	health_ui.hearts = stats.health
	
	sprite.material.shader = null
	health_ui.visible = true
	hurt_box.monitorable = true
	$CollisionShape2D.disabled = false
	
	global_position = respawn_point.position
	
	respawn_timer.stop()
	
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
	
func set_hunting_target(enemy):
	hunting_target = enemy
		
	var spawners = get_tree().get_nodes_in_group("Spawners")
	for spawner in spawners:
		if spawner.enemy == enemy:
			var loc = spawner.global_position + spawner.get_spawn_location()
			hunting_target_location = loc
			path = navigation.calculate_path(global_position, hunting_target_location)
			set_state(Global.States.Travel)
		
func get_enemy_position():
	if enemy_detector.can_see_enemy():
		var enemy = enemy_detector.enemy
		return enemy.global_position
	return null