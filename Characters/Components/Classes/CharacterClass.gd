extends Resource
class_name CharacterClass

#class
export(String) var name
export(String) var class_prefix
export(Global.Classes) var class_enum

#attack
export(int) var attack_range = 16

#stats
export(int) var int_starting = 1
export(int) var con_starting = 1
export(int) var str_starting = 1
export(int) var agi_starting = 1

export(int) var int_per_level = 1
export(int) var con_per_level = 1
export(int) var str_per_level = 1
export(int) var agi_per_level = 1

#abilities
export(Resource) var ability_1
export(Resource) var ability_2
export(Resource) var ability_3

