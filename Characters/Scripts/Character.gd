extends KinematicBody2D
class_name Character

#signal update_state(value)
#signal update_health(value)


#Onready vars
onready var animation_player = $AnimationPlayer
onready var enemy_detector = $EnemyDetector
onready var hitbox_pivot = $HitboxPivot
onready var hitbox = $HitboxPivot/Hitbox
onready var hitbox_area_shape = $HitboxPivot/Hitbox/CollisionShape2D
onready var attack_area = $HitboxPivot/AttackArea
onready var attack_area_shape = $HitboxPivot/AttackArea/CollisionShape2D
onready var attack_timer = $AttackTimer
onready var health_ui = $HealthUI
onready var stats = $Stats
onready var hurt_box = $Hurtbox
onready var sprite = $Sprite
onready var ability_manager = $AbilityManager
onready var navigation = get_node("/root/World/Navigation")
#onready var navigation_line = get_owner().get_node("Line2D")
onready var effect_manager = $EffectManager
onready var respawn_timer = $RespawnTimer
onready var respawn_point = $RespawnPoint
onready var soft_collisions = $SoftCollision
onready var inspect_ui = get_node("/root/World/UI/InspectUI")

#physics vars
export var acceleration = 300
export var max_speed = 50
export var friction = 200
export var rest_threshhold = .5
export var soft_collision_strength = 400

#navigations vars
var path = null
var paths_hit = 0
var paths_hit_recalculate = 5
var path_radius = 8
export(bool) var draw_path = false

#character vars
export(Global.Classes) var character_class = Global.Classes.None
export(int) var attack_range = 16
var class_prefix = ""
var state = Global.States.Idle
var velocity = Vector2.ZERO
var is_busy = false
export var respawn_time = 10


func _ready():
	#yield(get_owner(), "ready")
	attack_timer.start(stats.attack_speed)
	health_ui.max_hearts = stats.max_health
	health_ui.hearts = stats.max_health
	ability_manager.parent = self
	stats.stat_class = character_class	
	
	match character_class:
		Global.Classes.None:
			class_prefix = "default_"
		Global.Classes.Warrior:
			class_prefix = "warrior_"
			ability_manager.active_ability_1 = Global.Abilities.Warrior_Strengthen
		Global.Classes.Archer:
			class_prefix = "archer_"
		
	respawn_point.position = global_position	
		
	set_state(Global.States.Idle)
	
	print(str(class_prefix) + "(" + str(self) +  ") - Range - " + str(attack_range))
	print(hitbox_area_shape.shape.height)
	print(hitbox_area_shape.position.x)
		
	hitbox_area_shape.shape.height = attack_range
	hitbox_area_shape.position.x = attack_range / 2 + 8
	
	attack_area_shape.shape.radius = hitbox_area_shape.shape.radius
	attack_area_shape.shape.height = attack_range * 0.9
	attack_area_shape.position = hitbox_area_shape.position
	
	print(hitbox_area_shape.shape.height)
	print(hitbox_area_shape.position.x)
	

func _physics_process(delta):
	
	match state:
		Global.States.Idle:
			idle_state(delta)
		Global.States.Move:
			move_state(delta)
		Global.States.Attack:
			attack_state(delta)
		Global.States.Chase:
			chase_state(delta)
		Global.States.Rest:
			rest_state(delta)
		Global.States.Dead:
			dead_state()
				
	if soft_collisions.is_colliding():
		velocity += soft_collisions.get_push_vector() * delta * soft_collision_strength
	velocity = move_and_slide(velocity)

func flip_sprite():
	if velocity.normalized().x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func rest_state(_delta):
	if path != null:	
		move_along_path(_delta)
	else:
		if stats.health >= stats.max_health:
			set_state(Global.States.Idle)
		else:
			animation_player.play(class_prefix + "idle")
			velocity = Vector2.ZERO

func idle_state(_delta):
	path = null
	#if navigation_line != null:
		#navigation_line.points = []
	animation_player.play(class_prefix + "idle")	
	velocity = Vector2.ZERO
	
	var camp = false
	var hpercent = float(stats.health) / float(stats.max_health)
	if hpercent < rest_threshhold:
		camp = seek_closest_camp()
	
	# If health is higher than threshold, or no camp is found, find an enemy
	if not camp:
		seek_enemy()
		
		
func seek_closest_camp():
	var camps = get_tree().get_nodes_in_group("Camps")
	var closest_camp = null
	if camps.size() > 0:
		closest_camp = camps[0]
		for camp in camps:
			if global_position.distance_to(camp.global_position) < global_position.distance_to(closest_camp.global_position):
				closest_camp = camp
	if closest_camp != null:
		path = navigation.calculate_path(global_position, closest_camp.global_position)
		set_state(Global.States.Rest)
		return true
	else:
		print("no camp found")
		return false
	
func move_state(_delta):
	move_along_path(_delta)
	
func attack_state(_delta):
	velocity = Vector2.ZERO
	var enemy = enemy_detector.enemy	
	if is_busy == false:
		if enemy != null:
			if attack_timer.time_left == 0:
				#check ability manage timer
				var ability_activated = ability_manager.activate_ready_ability()
				if ability_activated != null:
					animation_player.play(class_prefix + ability_activated.to_lower())
				else:
					animation_player.play(class_prefix + "attack_right")
					is_busy = true
					
					hitbox.damage = get_effective_stat(Global.Stats.Strength)

				attack_timer.start(stats.attack_speed)
			else:
				if not attack_area.overlaps_body(enemy):
					set_state(Global.States.Chase)
		else:
			set_state(Global.States.Idle)
		

func attack_animation_finished():
	is_busy = false
	animation_player.play(class_prefix + "idle")
	
func chase_state(delta):	
	if not is_busy:
		var enemy = enemy_detector.enemy
		if enemy != null:
			var angle = rad2deg(get_angle_to(enemy.global_position))
			hitbox_pivot.rotation_degrees = angle
			
			#if in attack range		
			if attack_area.overlaps_body(enemy):
				animation_player.play(class_prefix + "idle")
				set_state(Global.States.Attack)
			else:
				if path != null:
					var buff = ability_manager.activate_buffs()
					if buff != null:
						animation_player.play(class_prefix + buff.to_lower())
						velocity = Vector2.ZERO
						is_busy = true
					else:
						move_along_path(delta)	
				else :
					set_state(Global.States.Idle)
		else:
			set_state(Global.States.Idle)

func move_along_path(delta):
	animation_player.play(class_prefix + "move")
	
	if (global_position.distance_to(path[0]) < path_radius):
		path.remove(0)
		#if draw_path:
#			navigation_line.points = path
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
			#if draw_path:
#				navigation_line.points = path	
			set_state(Global.States.Chase)
		else:
			print("can't find a path to " + enemy_detector.enemy.name)
			enemy_detector.get_next_enemy()
		

func _on_Hurtbox_area_entered(area : Area2D):
	if area.collision_layer == 8192: #EnemyHitbox
		stats.health -= area.damage
		health_ui.hearts = stats.health
		#inspect_ui.stats = stats
	
		hurt_box.create_hit_effect()
		if state == Global.States.Rest:
			seek_enemy()
	if area.collision_layer == 16: #CharacterHealbox
		stats.health += area.amount
		health_ui.hearts = stats.health
		#inspect_ui.stats = stats

func _on_Stats_no_health():
	#queue_free()
	#var enemy_death_effect_instance = enemy_death_effect.instance()
	#get_parent().add_child(enemy_death_effect_instance)
	#enemy_death_effect_instance.global_position = global_position
	global_position = respawn_point.position
	state = Global.States.Dead
	respawn_timer.start(respawn_time)
	visible = false

func set_state(new_state):
	var new_state_text = Global.States.keys()[new_state]
	state = new_state
	#inspect_ui.status = new_state_text


func _on_stats_changed():
	if stats != null:
		#inspect_ui.stats = stats
		pass


func _on_EnemyDetector_body_exited(body):
	if body.stats.level != null:		
		stats.experience += body.stats.level
		
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

func dead_state():
	velocity = Vector2.ZERO
	
func _on_RespawnTimer_timeout():
	state = Global.States.Idle
	
	stats.health = stats.max_health
	health_ui.hearts = stats.health
	#inspect_ui.stats = stats
	
	visible = true
	
	
