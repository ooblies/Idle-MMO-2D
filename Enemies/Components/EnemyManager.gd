extends Node

func create_enemy(enemy_class):
	var enemy_resource : EnemyClass = load("res://Enemies/Components/Classes/" + enemy_class + ".tres")
	var enemy_scene = load("res://Enemies/Scenes/Enemy.tscn")
	var enemy_instance : Enemy = enemy_scene.instance()
	
	enemy_instance.enemy_class = enemy_resource
	
	return enemy_instance
	
