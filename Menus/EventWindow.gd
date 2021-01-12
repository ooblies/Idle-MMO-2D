extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_message("Hello1");
	add_message("Hello2");
	add_message("Hello3");
	add_message("Hello4");
	add_message("Hello5");
	add_message("Hello6");
	add_message("Hello7");
	add_message("Hello8");
	add_message("Hello9");
	add_message("Hello10");
	add_message("Hello11");
	add_message("Hello12");
	add_message("Hello13");
	
func add_message(message: String):
	var l:Label = Label.new();
	l.text = message;
	$ScrollContainer/VBoxContainer.add_child(l);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EventWindow_toggled(button_pressed):
	$ScrollContainer.visible = button_pressed;
