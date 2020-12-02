extends Node
class_name EnemyStats

signal no_health
signal health_changed(value)
signal mana_changed(value)

signal stats_changed
var enemy_class : EnemyClass

var max_health setget , get_max_health
func get_max_health():
	if enemy_class != null:
		return get_constitution() * 10
	return null

var attack_damage setget , get_attack_damage
func get_attack_damage():
	if enemy_class != null:
		return get_strength()
	return null
	
export(int) var strength setget , get_strength
func get_strength():
	if enemy_class != null:
		return enemy_class.strength
	return null
	
export(int) var intelligence setget , get_intelligence
func get_intelligence():
	if enemy_class != null:
		return enemy_class.intelligence
	return null
	
export(int) var agility setget , get_agility
func get_agility():
	if enemy_class != null:
		return enemy_class.agility
	return null
	
export(int) var constitution setget , get_constitution
func get_constitution():
	if enemy_class != null:
		return enemy_class.constitution
	return null

var health setget set_health, get_health
func set_health(value):
	if max_health == null:
		max_health = get_max_health()
	if health == null:
		health = max_health	
	health = min(value,max_health)
	
	emit_signal("health_changed", health)
	if health == null:
		health = get_max_health()
	if health <= 0:
		emit_signal("no_health")
		
	emit_signal("stats_changed")

func get_health():
	if health == null:
		health = get_max_health()
		if max_health == null:
			max_health = get_max_health()
	return health	



func _ready():
	if enemy_class == null:
		enemy_class = get_parent().enemy_class
	strength = enemy_class.strength
	intelligence = enemy_class.intelligence
	constitution = enemy_class.constitution
	agility = enemy_class.agility
	
func init():
	pass
	#health = get_max_health()
	#experience = 0
	 

