extends Resource
class_name Ability



#ability
export(String) var name = ""
export(Global.Abilities) var ability_enum
export(Global.AbilityType) var ability_type = Global.AbilityType.Damage
export(Global.AbilityTargetType) var ability_target_type = Global.AbilityTargetType.EnemySingle
export(Global.AbilityShapes) var ability_shape = Global.AbilityShapes.Circle
export(Global.AbilityShapeCenter) var ability_shape_center = Global.AbilityShapeCenter.Self
export(int) var ability_radius = 0
export(Vector2) var ability_rectangle_size = Vector2.ZERO
#export(int) var ability_rectangle_angle = null
export(float) var cooldown
export(int) var mana_cost = 1
export(int) var level_required = 1

#damage
export(float) var base_damage = 0
export(float) var weapon_damage = 0
export(float) var strength_damange = 0
export(float) var intelligence_damage = 0
export(float) var agility_damage = 0
export(Global.DamageTypes) var damage_type = Global.DamageTypes.Melee

#heal
export(float) var base_heal = 0
export(float) var intelligence_heal = 0

#effect
export(float) var effect_duration = 0
export(float) var effect_frequency = 0

#ground effect
export(Texture) var ground_effect_texture = null
export(Vector3) var ground_effect_gravity = Vector3(0,-15,0) #floaty #-90 falling
export(Vector3) var ground_effect_direction = Vector3.DOWN #down
export(float) var ground_effect_initial_velocity = 0
export(float) var ground_effect_lifetime = 1
export(int) var ground_effect_amount = 8
export(Resource) var ground_effect_accel_curve = null
export(Vector2) var ground_effect_position_offset = Vector2.ZERO

#projectile
export(Texture) var projectile_texture = null
export(int) var projectile_speed = 250
export(float) var projectile_duration = 0.5
export(Vector2) var projectile_offset = Vector2.ZERO

#block
export(float) var base_block = 0
export(float) var block_percent = 0

#stats
export(Global.Stats) var effect_stat = Global.Stats.Strength
export(float) var effect_stat_increase_base = 0
export(float) var effect_stat_increase_multiplier = 0


var last_used

