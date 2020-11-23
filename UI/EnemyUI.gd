extends Control

#inspect
onready var title_row = $Panel/Stats/Title
onready var health_row = $Panel/Stats/RowHP
onready var class_row = $Panel/Stats/RowClass


var health setget set_health
func set_health(value):
	health = value
	health_row.get_node("Value").text = str(value)
	
var max_health setget set_max_health
func set_max_health(value):
	max_health = value
	health_row.get_node("Max").text = str(value)

#var stat_class setget set_stat_class
#func set_stat_class(value):
#	stat_class = Global.Classes.keys()[value]
#	class_row.get_node("Value").text = str(Global.Classes.keys()[value])

#var state setget set_state
#func set_state(value):
	#state = value
	#state_row.get_node("Value").text = str(value)	

func display_enemy_screen():
	
	display_enemy_stats()
	
func display_enemy_stats():
	var target = Global.InspectTarget
	var stats = target.stats
	title_row.text = target.enemy_class.name
	
	set_health(stats.health)
	set_max_health(stats.max_health)
	#set_stat_class(stats.stat_class)
	

func _ready():
	visible = false
	
func _process(_delta):
	var git = Global.InspectTarget
	
	if git != null:
		if git.is_in_group("Enemies"):
			visible = true
			display_enemy_screen()
		else:
			visible = false
	else:
		visible = false
