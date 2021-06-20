extends Node

enum EventType {
	Info,
	Chat,
	Combat
}


func _ready():
	pass

func send_message(message, type):
	get_node("/root/World/UI/EventWindow").add_message(message, type)
	#print(message);
