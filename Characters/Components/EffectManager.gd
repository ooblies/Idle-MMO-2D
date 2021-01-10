extends Node

var effect_scene = preload("res://Characters/Components/Effect.tscn")
onready var grid = $GridContainer

func _ready():
	pass # Replace with function body.

func add_effect(a : Ability):
	var effect = effect_scene.instance()
	var sprite_path = "res://Abilities/Icons/" + a.name + ".png"
	effect.get_node("Sprite").texture = load(sprite_path)
	effect.ability = a	
	grid.add_child(effect)
	effect.get_node("DurationTimer").start(a.effect_duration)
	
func get_damage_after_block(amount : float):
	var amt = amount
	for e in grid.get_children():
		if e.ability.base_block > 0:
			amt -= e.ability.base_block
		if e.ability.block_percent > 0:
			amt = amt * (1 - e.ability.block_percent)
	return amt

	
func get_stat_buff(stat, stats):	
	var increase_base = 0
	var increase_multi = 0
	for e in grid.get_children():
		if e.ability.effect_stat == stat:
			increase_base += e.ability.effect_stat_increase_base
			var multiplier = e.ability.effect_stat_increase_multiplier			
			if (increase_multi > 0):
				match stat:					
					Global.Stats.Agility:
						increase_multi += (multiplier * stats.agility) - stats.agility						
					Global.Stats.Strength:
						increase_multi += multiplier * stats.strength - stats.strength						
					Global.Stats.Constitution:
						increase_multi += multiplier * stats.constitution - stats.constitution
					Global.Stats.Intelligence:
						increase_multi += multiplier * stats.intelligence - stats.intelligence
					
	
	return increase_base + increase_multi
