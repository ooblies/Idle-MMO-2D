extends Resource
class_name Ability



#ability
export(String) var name = ""
export(Global.AbilityType) var ability_type = Global.AbilityType.Damage
export(Global.AbilityTargetType) var ability_target_type = Global.AbilityTargetType.EnemySingle
export(Global.AbilityShapes) var ability_shape = Global.AbilityShapes.Circle
export(Global.AbilityShapeCenter) var ability_shape_center = Global.AbilityShapeCenter.Self
export(int) var ability_radius = 0
export(Vector2) var ability_rectangle_size = Vector2.ZERO
export(float) var cooldown

#damage
export(float) var base_damage = 0
export(float) var weapon_damage = 0
export(float) var strength_damange = 0
export(float) var intelligence_damage = 0
export(float) var agility_damage = 0

#heal
export(float) var base_heal = 0
export(float) var intelligence_heal = 0

#effect
export(float) var effect_duration = 0
export(float) var effect_frequency = 0

#
export(float) var base_block = 0
export(float) var block_percent = 0

#stats
export(Global.Stats) var effect_stat = Global.Stats.Strength
export(float) var effect_stat_increase_base = 0
export(float) var effect_stat_increase_multiplier = 0


var last_used

