extends Area2D

const hit_effect = preload("res://Effects/HitEffect.tscn")

onready var timer = $InvincibilityTimer
onready var collision_shape = $CollisionShape2D

var invincible = false setget set_invincible

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var hit_effect_instance = hit_effect.instance()
	var main = get_tree().current_scene
	main.add_child(hit_effect_instance)
	hit_effect_instance.global_position = global_position

func _on_Timer_timeout():
	self.invincible = false

func _on_Hurtbox_invincibility_started():
	collision_shape.set_deferred("disabled",true)
	

func _on_Hurtbox_invincibility_ended():	
	collision_shape.disabled = false
