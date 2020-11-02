extends Control


onready var heart_ui_full = $HeartUIFull
onready var heart_ui_empty = $HeartUIEmpty

var hearts = 2 setget set_hearts
var max_hearts = 2 setget set_max_hearts


func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heart_ui_full != null:
		heart_ui_full.rect_size.x = hearts * 15
	

func set_max_hearts(value):
	max_hearts = max(value, 1)
	hearts = max_hearts	
	if heart_ui_full != null:
		heart_ui_full.rect_size.x = hearts * 15
	if heart_ui_empty != null:
		heart_ui_empty.rect_size.x = max_hearts * 15
		
	#center	
	rect_position.x = -1 * heart_ui_full.rect_size.x / 4

#func _ready():
	#elf.max_hearts = PlayerStats.max_health
	#elf.hearts = PlayerStats.health
	#Stats.connect("health_changed", self, "set_hearts")
	#layerStats.connect("max_health_changed", self, "set_max_hearts")
