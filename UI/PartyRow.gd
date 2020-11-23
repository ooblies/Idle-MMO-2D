extends VBoxContainer

var party_name = ""
onready var name_label = $Party/Name


# Called when the node enters the scene tree for the first time.
func _ready():
	name_label.text = party_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
