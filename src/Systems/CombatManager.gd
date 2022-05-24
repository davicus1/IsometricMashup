extends Node
class_name CombatManager 

signal Combat_Happened
signal Selected_Character_Changed(new_selected_character)
signal Heal_Character
signal Combat_Action(action)
enum COMBAT_ACTION{
	Mele,
	Ranged,
	Block,
	Heal
	}

var selected_character

func _init():
	connect("Combat_Action",self,"combat_action")
	connect("Selected_Character_Changed",self,"selected_character_changed")


func perform_combat_action(action,selected_character):
	var difficulty = 2
	var chanceToHit = 10 + difficulty # on a d20
	var weapon_damage = 0
	var defence_bonus = 0
	var healing_points = 0
	match action:
		"Mele":
			weapon_damage = 8
			chanceToHit += -2
		"Ranged":
			weapon_damage = 6
			chanceToHit += 2
		"Block":
			defence_bonus = 4
		"Heal":
			healing_points = 2
	
	randomize()
	
	if action == "Block":
		print("Your Action: %s" % action)
	elif action == "Heal":
		selected_character.heal(healing_points)
		print("Your Action: %s Healing Points: %s" % [action,healing_points])
	else:
		var toHitRoll = (randi() % 20) + 1
		var damage = 0
		if (toHitRoll >= chanceToHit):
			damage = (randi() % weapon_damage) + 1 # d8
		print("Your Action: %s Roll: %s/%s Damage : %s" % [action,toHitRoll,chanceToHit,damage])
		emit_signal("Combat_Happened",damage)


#Called by signals
func combat_action(action):
	perform_combat_action(action,selected_character)


#Called by signals
func selected_character_changed(new_selected_character):
	selected_character = new_selected_character

