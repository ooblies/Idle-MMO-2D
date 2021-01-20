extends Control

onready var panel = $Panel

export(int) var click_radius = 10

signal click

func _ready():
	panel.rect_size = Vector2(2*click_radius, 2*click_radius)
	panel.rect_position = Vector2(-1*click_radius, -1*click_radius)
	

func _on_Panel_pressed():
	emit_signal("click")
