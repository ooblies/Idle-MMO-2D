extends StaticBody2D

onready var navigation = get_owner().get_node("Navigation")
onready var collision_shape = $CollisionShape2D

func _ready():
	yield(navigation, "ready")
	navigation.disable_point(collision_shape.global_position, collision_shape.shape.radius)
