extends Resource
class_name EnemyClass

export(String) var name
export(String) var enemy_prefix
export(Global.Enemies) var enemy_enum

#attack
export(int) var attack_range = 16
export(int) var attack_speed = 2

#stats
export(int) var int_starting = 1
export(int) var con_starting = 1
export(int) var str_starting = 1
export(int) var agi_starting = 1

#exp
export(int) var level = 1
export(int) var exp_on_kill = 1
