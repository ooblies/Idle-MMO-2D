extends KinematicBody2D
class_name Enemy

const enemy_death_effect = preload("res://Effects/EnemyDeathEffect.tscn")

onready var stats = $EnemyStats
onready var player_detection = $PlayerDetection
onready var sprite = $Sprite
onready var hurt_box = $Hurtbox
onready var soft_collisions = $SoftCollision
onready var wander_controller = $WanderController
onready var health_ui = $HealthUI
onready var animation_player = $AnimationPlayer
onready var attack_timer = $AttackTimer
onready var hitbox_shape = $Hitbox/CollisionShape2D
onready var hitbox = $Hitbox
onready var nametag = $NameTag

#physics vars
var acceleration = 300
var max_speed = 50
var friction = 200
var wander_target_range = 4
var soft_collision_strength = 400

#enemy vars
var enemy_class : EnemyClass

#state vars
var state = Global.States.Chase
var is_attacking = false
var velocity = Vector2.ZERO

func _ready():
	stats.enemy_class = enemy_class
	hitbox.position.y = enemy_class.hitbox_offset_y
	
	state = pick_random_state([Global.States.Idle,Global.States.Wander])	
		
	#sprite.frame = rand_range(0,4)
	
	health_ui.max_hearts = stats.max_health	
	health_ui.hearts = stats.max_health	
	
	#class
	nametag.text = enemy_class.name
	hitbox_shape.shape.radius = enemy_class.attack_range
	attack_timer.start(enemy_class.attack_speed)

func _physics_process(delta):
	match state:
		Global.States.Idle:
			play_animation("idle")
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wander_controller.get_time_left() == 0:
				update_wander()
				
		Global.States.Wander:
			play_animation("idle")
			seek_player()
			if wander_controller.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wander_controller.target_position,delta)
			
			if global_position.distance_to(wander_controller.target_position) <= wander_target_range:
				update_wander()
			
		Global.States.Chase:
			play_animation("idle")
			
			if player_detection.player != null:
				#if in attack range
				if global_position.distance_to(player_detection.player.global_position) <= hitbox_shape.shape.radius:
					play_animation("idle")
					state = Global.States.Attack
				else :
					accelerate_towards_point(player_detection.player.global_position,delta)				
			else:
				state = Global.States.Idle
				
		Global.States.Attack:
			if is_attacking == false:
				velocity = Vector2.ZERO
				if player_detection.player != null:
					if attack_timer.time_left == 0:				
						var de = damage_event.new()
						de.attacker_level = enemy_class.level
						de.damage = stats.attack_damage
						de.damage_type = Global.DamageTypes.Melee
						hitbox.damage_event = de 
						
						play_animation("attack")
						attack_timer.start(enemy_class.attack_speed)
						is_attacking = true
						
					else:
						if global_position.distance_to(player_detection.player.global_position) > hitbox_shape.shape.radius:
							state = Global.States.Chase
				else:
					state = Global.States.Idle	

	if soft_collisions.is_colliding():
		velocity += soft_collisions.get_push_vector() * delta * soft_collision_strength
	
	velocity = move_and_slide(velocity)

func attack_animation_finished():
	is_attacking = false
	play_animation("idle")
	
func accelerate_towards_point(point, delta):
	var dir = global_position.direction_to(point)
	velocity = velocity.move_toward(dir * max_speed, acceleration * delta)
	
	sprite.flip_h = velocity.x < 0
	
func seek_player():
	if player_detection.can_see_player():
		state = Global.States.Chase

func update_wander():
	state = pick_random_state([Global.States.Idle,Global.States.Wander])
	wander_controller.start_wander_timer(rand_range(1,3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage_event.damage
	health_ui.hearts = stats.health
	
	hurt_box.create_hit_effect()

func _on_Clickable_click():
	Global.InspectTarget = self
	
func play_animation(name):
	var animation_name = enemy_class.enemy_prefix + name
	if animation_player.has_animation(animation_name):
		animation_player.play(animation_name)
	elif animation_player.has_animation("default_" + name):
		animation_player.play("default_" + name)
	else:
		print("UNHANDLED ANIMATION - enemy.gd")


func _on_EnemyStats_no_health():
	
	#death effect
	var enemy_death_effect_instance = enemy_death_effect.instance()
	get_parent().add_child(enemy_death_effect_instance)
	enemy_death_effect_instance.global_position = global_position
	
	var drop = LootManager.generate_drop_scene(enemy_class)
	if drop:
		get_parent().add_child(drop)
		drop.global_position = global_position
		drop.target = player_detection.player
	
	queue_free()
	
	ProgressionManager.increment_enemy_kill_count(enemy_class.enemy_enum)
	
	#TODO
	#give exp to nearby characters
