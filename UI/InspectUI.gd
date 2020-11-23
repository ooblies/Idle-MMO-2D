extends Control
#Tabs
onready var tabs = $TabContainer
onready var stats_tab = $TabContainer/Stats
onready var stats_tab_character = $TabContainer/Stats/CharacterSpecific
onready var abilities_tab = $TabContainer/Abilities
onready var party_tab = $TabContainer/Party

#inspect
onready var title_row = $TabContainer/Stats/Title
onready var health_row = $TabContainer/Stats/RowHP
onready var class_row = $TabContainer/Stats/RowClass
#character
onready var strength_row = $TabContainer/Stats/CharacterSpecific/RowStr
onready var intelligence_row = $TabContainer/Stats/CharacterSpecific/RowInt
onready var agility_row = $TabContainer/Stats/CharacterSpecific/RowAgi
onready var constitution_row = $TabContainer/Stats/CharacterSpecific/RowCon
onready var experience_row = $TabContainer/Stats/CharacterSpecific/RowExp
onready var level_row = $TabContainer/Stats/CharacterSpecific/RowLevel
onready var state_row = $TabContainer/Stats/CharacterSpecific/RowStatus
onready var task_row = $TabContainer/Stats/CharacterSpecific/RowTask/OptionButton
onready var hunt_enemy_row = $TabContainer/Stats/CharacterSpecific/EnemyType/OptionButton


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
	
var state setget set_state
func set_state(value):
	state = value
	state_row.get_node("Value").text = str(value)	

var experience setget set_experience
func set_experience(value):
	experience = value
	experience_row.get_node("Value").text = str(experience)	
	
var level setget set_level
func set_level(value):
	level = value
	level_row.get_node("Value").text = str(level)	


func display_character_screen():
	#camp_tab.visible = false
	#stats_tab.visible = true
	#stats_tab_character.visible = true
	#visible = true
	
	#tabs.set_tab_disabled(0,false) #stats
	#tabs.set_tab_disabled(1,false) #abilities
	#tabs.set_tab_disabled(2,false) #party
	#tabs.current_tab = 0
	
	display_character_stats()
	
func display_character_stats():
	var target = Global.InspectTarget
	var stats = target.stats
	title_row.text = target.character_name

	set_health(stats.health)
	set_max_health(stats.max_health)
	set_stat_class(stats.stat_class)
	set_strength(stats.strength)
	set_intelligence(stats.intelligence)
	set_agility(stats.agility)
	set_constitution(stats.constitution)
	set_experience(stats.experience)
	set_level(stats.level)
	set_state(Global.get_state_name(target.state))
	task_row.select(target.task)
	hunt_enemy_row.select(-1)
	if target.task == Global.Tasks.Hunt:
		hunt_enemy_row.get_parent().visible = true
	else:
		hunt_enemy_row.get_parent().visible = false


	
func display_enemy_screen():
	#camp_container.visible = false
	#stats_container.visible = true
	#character_specific_container.visible = false
	#visible = true
	#tabs.set_tab_disabled(0,false) #stats
	#tabs.set_tab_disabled(1,false) #abilities
	#tabs.set_tab_disabled(2,false) #party
	#tabs.set_tab_disabled(3,true) #camp
	#tabs.current_tab = 0
	
	display_enemy_stats()
	
func display_enemy_stats():
	var target = Global.InspectTarget
	var stats = target.stats
	title_row.text = target.enemy_name
	
	set_health(stats.health)
	set_max_health(stats.max_health)
	set_stat_class(stats.stat_class)
	

func _ready():
	visible = false
	task_row.add_item("Hunt", Global.Tasks.Hunt)
	task_row.add_item("Town", Global.Tasks.Town)
	
	hunt_enemy_row.add_item("None",-1)
	hunt_enemy_row.add_item("Bat", Global.Enemies.Bat)
	hunt_enemy_row.add_item("Mouse", Global.Enemies.Mouse)
	
func _process(_delta):
	var git = Global.InspectTarget
	
	if git != null:
		if git.is_in_group("Characters"):
			visible = true
			display_character_screen()
		elif git.is_in_group("Enemies"):
			visible = true
			display_enemy_screen()
		else:
			visible = false
		
	else:
		visible = false
		

#select task
func _on_OptionButton_item_selected(index):
	Global.InspectTarget.task = index
	if index == Global.Tasks.Hunt:
		display_character_stats()


func _on_enemy_type_selected(enemy):
	enemy -= 1
	#-1 is NONE
	if enemy >= 0:
		Global.InspectTarget.set_hunting_target(enemy)
