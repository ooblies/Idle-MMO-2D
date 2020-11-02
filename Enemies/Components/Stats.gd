extends Node
class_name Stats

signal no_health
signal health_changed(value)
#signal max_health_changed(value)
signal stats_changed

var max_health setget , get_max_health
#func set_max_health(value):
	#max_health = value
	#self.health = min(health, max_health)
	#emit_signal("max_health_changed", max_health)
func get_max_health():
	return constitution

var attack_damage setget , get_attack_damage
func get_attack_damage():
	return strength
	
export(float) var attack_speed = 1 setget , get_attack_speed
func get_attack_speed():
	return attack_speed
	
export(int) var strength = 1 setget , get_strength
func get_strength():
	return strength
	
export(int) var intelligence = 1 setget , get_intelligence
func get_intelligence():
	return intelligence
	
export(int) var agility = 1 setget , get_agility
func get_agility():
	return agility
	
export(int) var constitution = 1 setget , get_constitution
func get_constitution():
	return constitution

export(int) var experience = 1 setget set_experience , get_experience
func set_experience(value):
	experience = value
	emit_signal("stats_changed")
func get_experience():
	return experience

var level setget , get_level
func get_level():
	return floor(experience / 10) + 1

var health = get_max_health() setget set_health
func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health == null:
		health = get_max_health()
	if health <= 0:
		emit_signal("no_health")
		
	emit_signal("stats_changed")

export var stat_name = "Test"
export(Global.Classes) var stat_class

func _ready():
	self.health = max_health

