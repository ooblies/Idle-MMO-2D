class_name Party

var characters = []
var leader = null

export var name = "Default Party Name"

func add_character(c):
	var new_char = true
	for i in characters.size():
		if characters[i] == c:
			new_char = false
	if new_char:
		if characters.size() == 0:
			leader = c
		characters.append(c)
		c.party = self
		
func is_party_leader(c):
	if c == leader:
		return true
	else:
		return false
		
func set_attack_target(target):
	for character in characters:
		character.enemy_detector.enemy = target
		character.move_to_enemy(target)
		

func remove_character(c):
	for i in characters.size():
		if characters[i] == c:
			characters.remove(i)
			c.party = null
	if characters.size() == 0:
		leader = null

func is_character_in_party(c):
	for character in characters:
		if character == c:
			return true
	return false

func get_characters():
	return characters

func set_state(state):
	for character in characters:
		character.set_state(state)
		
func set_task(task):
	for character in characters:
		character.task = task
		
func set_hunting_target(target):
	for character in characters:
		character.set_hunting_target(target)

func has_res():
	var can = false
	for character in characters:
		#if has priest in party
		#if priest is alive
		#if priest has res
		#if priest has mana for res
		if character.character_class.class_enum == Global.Classes.Priest \
			&& character.state != Global.States.Dead \
			&& character.ability_manager.active_ability_3 != null \
			&& character.stats.mana >= character.character_class.ability_3.mana_cost:
			can = true
	return can

func get_dead_member():
	var dead = null
	for character in characters:
		if character.state == Global.States.Dead:
			dead = character
	return dead
