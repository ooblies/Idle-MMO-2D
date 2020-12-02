extends KinematicBody2D
class_name Projectile

var speed = 10
var texture : Texture = null
var target : Vector2
var velocity : Vector2 = Vector2.ZERO
var duration : float = 1
var offset : Vector2 = Vector2.ZERO
var p_rotation : float = 0

func _ready():
	if texture != null:
		$Sprite.texture = texture
	$Timer.start(duration)
	rotation = deg2rad(p_rotation)
	$Sprite.offset = offset.rotated(deg2rad(p_rotation))


func _process(delta):
	velocity = Vector2(1,0).rotated(deg2rad(p_rotation)) * speed * delta
	var _temp = move_and_collide(velocity)


func _on_Timer_timeout():
	queue_free()
