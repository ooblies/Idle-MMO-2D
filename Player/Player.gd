extends KinematicBody2D

const MAX_SPEED = 100
const ACCELERATION = 600
const FRICTION = 600
const ROLL_SPEED = 150

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
#var stats = PlayerStats

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sword_hitbox = $HitboxPivot/SwordHitbox
onready var hurt_box = $Hurtbox

func _ready():
	animation_tree.active = true
	sword_hitbox.knockback_vector = roll_vector
	#stats.connect("no_health",self,"queue_free")

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
func attack_state(delta):
	velocity = Vector2.ZERO
	animation_state.travel("Attack")

func attack_animation_finished():
	state = MOVE

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animation_state.travel("Roll")
	move()
	
func roll_animation_finished():
	velocity = Vector2.ZERO
	state = MOVE	
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()	
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hitbox.knockback_vector = input_vector
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)			
		
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_state.travel("Run")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)	
		animation_state.travel("Idle")
	
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("roll"):
		state = ROLL
		
func move():
	velocity = move_and_slide(velocity)


func _on_Hurtbox_area_entered(area):
	#stats.health -= 1
	hurt_box.start_invincibility(0.5)
	hurt_box.create_hit_effect()
