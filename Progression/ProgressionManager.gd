extends Node

var character_count = 0
var max_warrior_level = 0
var max_archer_level = 0
var max_priest_level = 0
var warrior_count = 0
var archer_count = 0
var priest_count = 0

var mice_killed = 0
var bats_killed = 0
var boars_killed = 0

func increment_enemy_kill_count(enemy_class):
	match enemy_class:
		Global.Enemies.Mouse:
			mice_killed = mice_killed + 1
		Global.Enemies.Bat:
			bats_killed = bats_killed + 1
		Global.Enemies.Boar:
			bats_killed = boars_killed + 1

func get_character_counts_and_levels():
	var characters = get_tree().get_nodes_in_group("Characters")
	character_count = characters.size()
		
	warrior_count = 0
	archer_count = 0
	priest_count = 0
	for character in characters:
		if character.stats.character_class.class_enum == Global.Classes.Warrior:
			warrior_count += 1
			if character.stats.level > max_warrior_level:
				max_warrior_level = character.stats.level
				
		if character.stats.character_class.class_enum == Global.Classes.Archer:
			archer_count += 1
			if character.stats.level > max_archer_level:
				max_archer_level = character.stats.level
				
		if character.stats.character_class.class_enum == Global.Classes.Priest:
			priest_count += 1
			if character.stats.level > max_priest_level:
				max_priest_level = character.stats.level

func can_create_character(character_class):
	get_character_counts_and_levels()
	match character_class:
		Global.Classes.Warrior:
			if character_count == 0:
				return true
			if warrior_count <= 1 && max_warrior_level >= 10:
				return true
				
			return false			
		Global.Classes.Archer:
			if archer_count == 0 && max_warrior_level >= 5:
				return true
			if archer_count == 1 && max_archer_level >= 10:
				return true
			return false
		
		Global.Classes.Priest:
			if priest_count == 0 && max_archer_level >= 5:
				return true
			if priest_count == 1 && max_priest_level >= 10:
				return true
			return false
	return false
	
	
func get_create_character_warning_message(character_class):
	var characters = get_tree().get_nodes_in_group("Characters")
	
	get_character_counts_and_levels()
	
	
	match character_class:
		Global.Classes.Warrior:
			if character_count == 0:
				return ""
			if warrior_count == 1 && max_warrior_level <= 10:
				return "Reach Warrior lvl 10"
		Global.Classes.Archer:
			if archer_count == 0 && max_warrior_level <= 5:
				return "Reach Warrior lvl 5"
			if archer_count == 1 && max_archer_level <= 10:
				return "Reach Archer lvl 10"
		Global.Classes.Priest:			
			if mice_killed < 5:
				return "Kill " + str(5 - mice_killed) + " more mice"
			if mice_killed >= 5 && max_priest_level <= 10:
				return "Reach Priest lvl 10"
	return ""
	
