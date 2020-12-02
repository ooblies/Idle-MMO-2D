extends Node
class_name PlayerStats

signal no_health
signal health_changed(value)
signal mana_changed(value)
signal xp_changed(value)
#signal max_health_changed(value)
signal stats_changed
var character_class : CharacterClass

var max_health setget , get_max_health
#func set_max_health(value):
	#max_health = value
	#self.health = min(health, max_health)
	#emit_signal("max_health_changed", max_health)
func get_max_health():
	return get_constitution() * 10

var attack_damage setget , get_attack_damage
func get_attack_damage():
	return strength
	
export(float) var attack_speed = 1 setget , get_attack_speed
func get_attack_speed():
	return attack_speed
	
export(int) var strength setget , get_strength
func get_strength():
	if character_class != null:
		return character_class.str_starting + (get_level() * character_class.str_per_level)
	return null
	
export(int) var intelligence setget , get_intelligence
func get_intelligence():
	if character_class != null:
		return character_class.int_starting + (get_level() * character_class.int_per_level)
	return null
	
export(int) var agility setget , get_agility
func get_agility():
	if character_class != null:
		return character_class.agi_starting + (get_level() * character_class.agi_per_level)
	return null
	
export(int) var constitution setget , get_constitution
func get_constitution():
	if character_class != null:
		return character_class.con_starting + (get_level() * character_class.con_per_level)
	return null

export(int) var experience setget set_experience , get_experience
func set_experience(value):
	experience = value
	emit_signal("xp_changed", experience)	
	emit_signal("stats_changed")
func get_experience():
	return experience

var level = 1 setget , get_level
func get_level():
	return Global.get_level_from_experience(experience)

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

var max_mana setget , get_max_mana
func get_max_mana():
	return get_intelligence() * 10

var mana setget set_mana, get_mana
func set_mana(value):
	if max_mana == null:
		max_mana = get_max_mana()
	if mana == null:
		mana = max_mana
	mana = min(value, get_max_mana())
	
	emit_signal("mana_changed", mana)	
	emit_signal("stats_changed")
func get_mana():
	if mana == null:
		mana = get_max_mana()
		if max_mana == null:
			max_mana = get_max_mana()
	return mana

func get_health():
	if health == null:
		health = get_max_health()
		if max_health == null:
			max_health = get_max_health()
	return health	

var attack_range setget ,get_attack_range
func get_attack_range():
	if character_class != null:
		return character_class.attack_range
	return null



func _ready():
	pass
	
func init():
	pass
	#health = get_max_health()
	#experience = 0
	 

