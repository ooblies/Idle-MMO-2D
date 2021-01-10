extends Control

onready var create_character = $Panel/CreateCharacter
onready var character_sort = $"/root/World/YSort/Characters"

func _ready():
	visible = false
	
func _process(_delta):
	var git = Global.InspectTarget
	
	if git != null:
		if git.is_in_group("Camps"):
			visible = true
			display_camp_screen()
		else:
			visible = false
	else:
		visible = false
		

func display_camp_screen():
	#To-Do: load classes dynamically
	#Warrior
	create_character.get_node("Warrior/Button").disabled = !ProgressionManager.can_create_character(Global.Classes.Warrior)
	if create_character.get_node("Warrior/Button").disabled:
		create_character.get_node("Warrior/VBoxContainer/Warning").visible = true
		create_character.get_node("Warrior/VBoxContainer/Warning").text = ProgressionManager.get_create_character_warning_message(Global.Classes.Warrior)
	else:
		create_character.get_node("Warrior/VBoxContainer/Warning").visible = false
		
	#Archer
	create_character.get_node("Archer/Button").disabled = !ProgressionManager.can_create_character(Global.Classes.Archer)
	if create_character.get_node("Archer/Button").disabled:
		create_character.get_node("Archer/VBoxContainer/Warning").visible = true
		create_character.get_node("Archer/VBoxContainer/Warning").text = ProgressionManager.get_create_character_warning_message(Global.Classes.Archer)
	else:
		create_character.get_node("Archer/VBoxContainer/Warning").visible = false
		
	#Archer
	create_character.get_node("Priest/Button").disabled = !ProgressionManager.can_create_character(Global.Classes.Priest)
	if create_character.get_node("Priest/Button").disabled:
		create_character.get_node("Priest/VBoxContainer/Warning").visible = true
		create_character.get_node("Priest/VBoxContainer/Warning").text = ProgressionManager.get_create_character_warning_message(Global.Classes.Priest)
	else:
		create_character.get_node("Priest/VBoxContainer/Warning").visible = false

	
func _create_character(character_class):	
	print("Spawn " + character_class)
	var character : Character = CharacterManager.create_character(character_class)
		
	character.set_global_position(Global.InspectTarget.get_target_position())
	character_sort.add_child(character)
	#create_popup.popup(Rect2(Vector2(100,100),Vector2(256,64)))
	
	display_camp_screen()
