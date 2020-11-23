extends Control


onready var heart_ui_full = $HeartUIFull
onready var heart_ui_empty = $HeartUIEmpty

onready var health_progress = $HealthProgress
onready var mana_progress = $ManaProgress
onready var experience_progress = $XPProgress
#onready var tween = $Tween

var hearts = 2 setget set_hearts
var max_hearts = 2 setget set_max_hearts

var mana = 1 setget set_mana
func set_mana(value):
	mana_progress.value = value
	mana = value
var max_mana = 1 setget set_max_mana
func set_max_mana(value):
	max_mana = value
	mana_progress.max_value = value
	mana_progress.value = value

var experience = 0 setget set_experience
func set_experience(value):
	experience_progress.value = value
	experience = value
	experience_progress.max_value = Global.get_experience_at_next_level(experience)
	experience_progress.min_value = Global.get_experience_at_previous_level(experience)
	
#var max_experience = 1 setget set_max_experience
#func set_max_experience(value):
	#max_experience = value
	#experience_progress.max_value = value
	#experience_progress.value = value

#var animated_health = 2


func set_hearts(value):
	#hearts = clamp(value, 0, max_hearts)
	#if heart_ui_full != null:
		#heart_ui_full.rect_size.x = hearts * 15
	health_progress.value = value
	hearts = value
	#label.text = str(round(value))
	#animation
	#tween.interpolate_property(self, "animated_health",animated_health,value, 0.1)
	#if not tween.is_active():
	#tween.start()
	
	

func set_max_hearts(value):
	max_hearts = max(value, 1)
	#hearts = max_hearts	
	#if heart_ui_full != null:
		#heart_ui_full.rect_size.x = hearts * 15
	#if heart_ui_empty != null:
		#heart_ui_empty.rect_size.x = max_hearts * 15
		
	#center	
	#rect_position.x = -1 * heart_ui_full.rect_size.x / 4
	
	health_progress.max_value = value
	health_progress.value = max_hearts
	#animated_health = value

#func _process(delta):
	#progress.value = animated_health
	
#func _ready():
	#elf.max_hearts = PlayerStats.max_health
	#elf.hearts = PlayerStats.health
	#Stats.connect("health_changed", self, "set_hearts")
	#layerStats.connect("max_health_changed", self, "set_max_hearts")
