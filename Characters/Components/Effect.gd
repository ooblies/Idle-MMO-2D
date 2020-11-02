extends Node
class_name Effect

onready var ability : Ability
onready var frequency_timer = $FrequencyTimer
onready var duration_timer = $DurationTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	duration_timer.start(ability.effect_duration)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DurationTimer_timeout():
	queue_free()


func _on_FrequencyTimer_timeout():
	pass # Replace with function body.
