extends Camera2D

onready var top_left = $Limits/TopLeft
onready var bottom_right = $Limits/BottomRight

export(float) var zoom_level  = 1
export(int) var move_speed = 300
export(int) var camera_inspect_offset = 50
export(float) var max_zoom = 1
export(float) var min_zoom = .1
export(float) var zoom_step = .1
export(float) var inspect_zoom_level = .3

var inspecting_target = null

func _ready():
	#limit_top = top_left.position.y
	#limit_left = top_left.position.x
	#limit_right = bottom_right.position.x
	#limit_bottom = bottom_right.position.y
	
	#var world = get_tree().get_root().get_node("World")
	#var _cnct = connect("cancel_inspect", world ,"_cancel_inspect")
	
	update_zoom(zoom_level)
	
func _process(delta):
	
	if Input.is_action_just_released("ui_scroll_up"):
		update_zoom(clamp(zoom_level - zoom_step, min_zoom, max_zoom))
		
	if Input.is_action_just_released("ui_scroll_down"):
		update_zoom(clamp(zoom_level + zoom_step, min_zoom, max_zoom))
		
	if Input.is_action_pressed("ui_left"):
		if Global.InspectTarget == null:
			position.x -= move_speed * zoom_level * delta
		
	if Input.is_action_pressed("ui_right"):
		if Global.InspectTarget == null:
			position.x += move_speed * zoom_level * delta
	
	if Input.is_action_pressed("ui_up"):
		if Global.InspectTarget == null:
			position.y -= move_speed * zoom_level * delta
		
	if Input.is_action_pressed("ui_down"):
		if Global.InspectTarget == null:
			position.y += move_speed * zoom_level * delta
		
	if Global.InspectTarget != null:
		inspect_follow()
		update_zoom(inspect_zoom_level)
	else:
		inspecting_target = null
		
			
func update_zoom(level):
	zoom_level = level
	zoom.x = level
	zoom.y = level
	
func inspect_follow():
	var new_pos = Global.InspectTarget.global_position
	new_pos.x -= camera_inspect_offset * zoom_level
	position = new_pos
