extends Resource
class_name EnemyClass

export(String) var name
export(String) var enemy_prefix
export(Global.Enemies) var enemy_enum

#attack
export(int) var attack_range = 16
export(int) var attack_speed = 2

#stats
export(int) var intelligence = 1
export(int) var constitution = 1
export(int) var strength = 1
export(int) var agility = 1

#defence
export(int) var armor = 1
export(int) var magic_resist = 1

#exp
export(int) var level = 1
export(int) var exp_on_kill = 1

#offset
export(int) var hitbox_offset_y = 0

