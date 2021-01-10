extends Node #need to spawn characters

var gold : int = 0 setget set_gold
func set_gold(value):
	gold = value
	get_node("/root/World/UI/Gold").text = str(gold)

enum Stats {
	Constitution,
	Strength,
	Intelligence,
	Agility,
	None
}

enum Classes {
	Enemy,
	Warrior,
	Archer,
	Priest,
	None
}

enum Enemies {
	Mouse,
	Bat,
	Boar
}

enum Abilities {
	Test_CircleAttack,
	Test_RectangleAttack,
	Warrior_Strengthen,
	Warrior_BigAttack,
	Warrior_Block,
	Priest_Heal,
	Priest_Regen,
	Priest_Resurrect,
	Archer_RainOfArrows,
	Archer_DoubleShot,
	Archer_Snipe
}

enum States {
	Idle,
	Move,
	Chase,
	Attack,
	Wander,
	Rest,
	Dead,
	Travel
}

enum Tasks {
	Town,
	Hunt
}

enum AbilityType {
	Damage,
	Heal,
	Resurrect,
	Effect
}

enum AbilityTargetType {
	EnemySingle,	
	Shaped,
	FriendlyLowest,
	FriendlyAll,
	Self
}

enum AbilityShapes {
	None,
	Circle,
	Rectangle
}

enum AbilityShapeCenter {
	None,
	Self,
	Target
}

enum EquipmentSlot {
	MainHand,
	OffHand,
	Head,
	Chest,
	Hands,
	Legs,
	Feet,
	Finger,
	Neck,
	None
}

enum EquipmentTier {
	Wooden,
	Leather,
	Iron,
	Gold,
	Diamond,
	None
}

enum DamageTypes {
	Melee,
	Magic,
	None
}

enum Items {
	Wooden_1h_Sword
}

func get_state_name(state):
	return States.keys()[state]

var default_names = ["Liam","Noah","William","James","Oliver","Benjamin","Elijah","Lucas","Mason","Logan","Alexander","Ethan",
			"Emma","Olivia","Ava","Isabella","Sophia","Charlotte","Mia","Amelia","Harper","Evelyn","Abigail","Emily","Elizabeth"]

func get_random_name():
	var name_index = randi() % 25
	return default_names[name_index]

var InspectTarget

var level_breakpoints = [ #0
	  1, 8, 17, 28, 39, 51, 65, 80, 97, 115 #1-10
	, 136, 158, 183, 211, 241, 275, 312, 352, 397, 447 #11-20
	, 502, 562, 629, 703, 784, 874, 973, 1082, 1203, 1336 #21-30
	, 1483, 1646, 1825, 2022, 2241, 2482, 2747, 3041, 3365, 3722 #31-40
	, 4117, 4553, 5034, 5565, 6151, 6798, 7513, 8301, 9172, 10133 #41-50
	, 11195, 12366, 13659, 15087, 16664, 18404, 20325, 22447, 24789, 27374 #51-60
	, 30229, 33380, 36860, 40702, 44943, 49625, 54795, 60503, 66805, 73763 #61-70
	, 81445, 89926, 99290, 109628, 121042, 133644, 147558, 162920, 179881, 198607 #71-80
	, 219282, 242109, 267311, 295137, 325859, 359779, 397229, 438578, 484230, 534633 #81-90
	, 590283, 651725, 719563, 794461, 877156, 968458, 1069263, 1180561, 1303443 #91-99
]

func get_level_from_experience(experience):	
	for level in level_breakpoints.size():
		if experience < level_breakpoints[level]:
			return level
			
func get_experience_at_next_level(experience):
	for level in level_breakpoints.size():
		if experience < level_breakpoints[level]:
			return level_breakpoints[level]
			
func get_experience_at_previous_level(experience):
	var previous_level = get_level_from_experience(experience) - 1
	return level_breakpoints[previous_level]

#To-Do: move below to new helper?
func can_create_character(character_class):	
	#return true
	
	var characters = get_tree().get_nodes_in_group("Characters")
	var character_count = characters.size()
	var max_warrior_level = 0
	var max_archer_level = 0
	var max_priest_level = 0
	var warrior_count = 0
	var archer_count = 0
	var priest_count = 0
	
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
	var character_count = characters.size()
	var max_warrior_level = 0
	var max_archer_level = 0
	var max_priest_level = 0
	var warrior_count = 0
	var archer_count = 0
	var priest_count = 0
	
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
			if priest_count == 0 && max_archer_level <= 5:
				return "Reach Archer lvl 5"
			if priest_count == 1 && max_priest_level <= 10:
				return "Reach Priest lvl 10"
	return ""
	
	

