extends KinematicBody2D

const enemy_death_effect = preload("res://Effects/EnemyDeathEffect.tscn")

onready var stats = $Stats
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

export var acceleration = 300
export var max_speed = 50
export var friction = 200
export var wander_target_range = 4
export var soft_collision_strength = 400


var state = Global.States.Chase

var is_attacking = false
var velocity = Vector2.ZERO

func _ready():
	state = pick_random_state([Global.States.Idle,Global.States.Wander])	
	
	attack_timer.start(stats.attack_speed)
	
	sprite.frame = rand_range(0,4)
	
	health_ui.max_hearts = stats.max_health	
	health_ui.hearts = stats.max_health	

func _physics_process(delta):
	match state:
		Global.States.Idle:
			animation_player.play("idle")
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wander_controller.get_time_left() == 0:
				update_wander()
				
		Global.States.Wander:
			animation_player.play("idle")
			seek_player()
			if wander_controller.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wander_controller.target_position,delta)
			
			if global_position.distance_to(wander_controller.target_position) <= wander_target_range:
				update_wander()
			
		Global.States.Chase:
			animation_player.play("idle")
			
			var player = player_detection.player
			if player != null:
				#if in attack range
				if global_position.distance_to(player.global_position) <= hitbox_shape.shape.radius:
					animation_player.play("idle")
					state = Global.States.Attack
				else :
					accelerate_towards_point(player.global_position,delta)				
			else:
				state = Global.States.Idle
				
		Global.States.Attack:
			velocity = Vector2.ZERO
			var player = player_detection.player
			if is_attacking == false:
				if player != null:
					if attack_timer.time_left == 0:				
						animation_player.play("attack")
						attack_timer.start(stats.attack_speed)
						is_attacking = true
						hitbox.damage = stats.attack_damage
					else:
						if global_position.distance_to(player.global_position) > hitbox_shape.shape.radius:
							state = Global.States.Chase
				else:
					state = Global.States.Idle	

	if soft_collisions.is_colliding():
		velocity += soft_collisions.get_push_vector() * delta * soft_collision_strength
	
	velocity = move_and_slide(velocity)

func attack_animation_finished():
	is_attacking = false
	animation_player.play("idle")
	
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
	stats.health -= area.damage
	health_ui.hearts = stats.health
	
	hurt_box.create_hit_effect()

func _on_Stats_no_health():
	#delete node
	queue_free()
	
	#death effect
	var enemy_death_effect_instance = enemy_death_effect.instance()
	get_parent().add_child(enemy_death_effect_instance)
	enemy_death_effect_instance.global_position = global_position

	#give exp to nearby characters


func _on_PlayerDetection_body_exited(_body):
	pass # Replace with function body.
