extends Node
class_name Stats

signal no_health
signal health_changed(value)
signal mana_changed(value)
signal xp_changed(value)
#signal max_health_changed(value)
signal stats_changed

var max_health setget , get_max_health
#func set_max_health(value):
	#max_health = value
	#self.health = min(health, max_health)
	#emit_signal("max_health_changed", max_health)
func get_max_health():
	return constitution * 10

var attack_damage setget , get_attack_damage
func get_attack_damage():
	return strength
	
export(float) var attack_speed = 1 setget , get_attack_speed
func get_attack_speed():
	return attack_speed
	
export(int) var strength = 1 setget , get_strength
func get_strength():
	return character_class.str_starting + (level * character_class.str_per_level)
	
export(int) var intelligence = 1 setget , get_intelligence
func get_intelligence():
	return character_class.int_starting + (level * character_class.int_per_level)
	
export(int) var agility = 1 setget , get_agility
func get_agility():
	return character_class.agi_starting + (level * character_class.agi_per_level)
	
export(int) var constitution = 1 setget , get_constitution
func get_constitution():
	return character_class.con_starting + (level * character_class.con_per_level)

export(int) var experience = 0 setget set_experience , get_experience
func set_experience(value):
	experience = value
	emit_signal("xp_changed", experience)	
	emit_signal("stats_changed")
func get_experience():
	return experience

var level = 1 setget , get_level
func get_level():
	return Global.get_level_from_experience(experience)

var health = get_max_health() setget set_health, get_health
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
	return intelligence

var mana setget set_mana, get_mana
func set_mana(value):
	if max_mana == null:
		max_mana = get_max_mana()
	if mana == null:
		mana = max_mana
	mana = min(value, max_mana)
	
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
	return character_class.attack_range


var character_class : CharacterClass

func _ready():
	health = max_health

