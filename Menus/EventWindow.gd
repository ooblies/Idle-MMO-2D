extends Control

onready var container = $ScrollContainer
onready var v_box = $ScrollContainer/VBoxContainer
onready var auto = $AutoScroll
onready var show = $Show
signal send_message
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	container.visible = show.pressed
	
func add_message(message: String, type):
	var l:Label = Label.new();
	l.text = message;
	match type:
		EventManager.EventType.Chat:
			l.text = "Chat - " + l.text
		EventManager.EventType.Info:
			l.text = "Info - " + l.text
		EventManager.EventType.Combat:
			l.text = "Combat - " + l.text
		
	v_box.add_child(l);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (auto.pressed):
		container.scroll_vertical = container.get_v_scrollbar().max_value


func _on_EventWindow_toggled(button_pressed):
	container.visible = button_pressed;
