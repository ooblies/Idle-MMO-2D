extends Control

onready var name_row = $Panel/VBoxContainer/Title
onready var health_row = $Panel/VBoxContainer/RowHP
onready var class_row = $Panel/VBoxContainer/RowClass
#character
onready var character_specific_container = $Panel/VBoxContainer/CharacterSpecific
onready var strength_row = $Panel/VBoxContainer/CharacterSpecific/RowStr
onready var intelligence_row = $Panel/VBoxContainer/CharacterSpecific/RowInt
onready var agility_row = $Panel/VBoxContainer/CharacterSpecific/RowAgi
onready var constitution_row = $Panel/VBoxContainer/CharacterSpecific/RowCon
onready var status_row = $Panel/VBoxContainer/CharacterSpecific/RowStatus
onready var experience_row = $Panel/VBoxContainer/CharacterSpecific/RowExp


var stats : Stats setget set_stats
func set_stats(value):
	if inspect_target != null:
		if value == inspect_target.stats:
			stats = value
		
			set_health(stats.health)
			set_max_health(stats.max_health)
			set_stat_class(stats.stat_class)
			set_strength(stats.strength)
			set_intelligence(stats.intelligence)
			set_agility(stats.agility)
			set_constitution(stats.constitution)
			set_experience(stats.experience)

var health setget set_health
func set_health(value):
	health = value
	health_row.get_node("Value").text = str(value)
	
var max_health setget set_max_health
func set_max_health(value):
	max_health = value
	health_row.get_node("Max").text = str(value)

var stat_class setget set_stat_class
func set_stat_class(value):
	stat_class = Global.Classes.keys()[value]
	class_row.get_node("Value").text = str(Global.Classes.keys()[value])

var strength setget set_strength
func set_strength(value):
	strength = value
	strength_row.get_node("Value").text = str(value)
	
var intelligence setget set_intelligence
func set_intelligence(value):
	intelligence = value
	intelligence_row.get_node("Value").text = str(value)
	
var agility setget set_agility
func set_agility(value):
	agility = value
	agility_row.get_node("Value").text = str(value)
	
var constitution setget set_constitution
func set_constitution(value):
	constitution = value
	constitution_row.get_node("Value").text = str(value)
	
var status setget set_status
func set_status(value):
	status = value
	status_row.get_node("Value").text = str(value)	

var experience setget set_experience
func set_experience(value):
	experience = value
	experience_row.get_node("Value").text = str(experience)
	print("exp - " + str(experience))

var inspect_target setget set_target
func set_target(target):
	if target != null:
		print("Inspecting " + str(target))
		visible = true
		name_row.text = target.stats.stat_name
		inspect_target = target
		set_stats(target.stats)	
		
		if target.stats.stat_class == Global.Classes.Enemy:
			character_specific_container.visible = false
		else:			
			character_specific_container.visible = true
		
	else:
		visible = false

func _ready():
	visible = false
	
	
