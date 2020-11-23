extends HBoxContainer

var ability : Ability
var active = false

onready var label = $Label
onready var toggle = $Active

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = ability.name
	toggle.pressed = active
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
