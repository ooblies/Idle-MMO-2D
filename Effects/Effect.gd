extends AnimatedSprite

func _ready():
	var _temp = connect("animation_finished", self, "_on_animation_finished")
	play("animate")

func _on_animation_finished():
	queue_free()
