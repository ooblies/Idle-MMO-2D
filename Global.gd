extends Node

enum Stats {
	Constitution,
	Strength,
	Intelligence,
	Agility
}

enum Classes {
	Enemy,
	Warrior,
	Archer,
	None
}

enum Enemies {
	Bat,
	Mouse
}

enum Abilities {
	Test_CircleAttack,
	Test_RectangleAttack,
	Warrior_Strengthen
}

enum States {
	Idle,
	Move,
	Chase,
	Attack,
	Wander,
	Rest,
	Dead
}

enum AbilityType {
	Damage,
	Heal,
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

