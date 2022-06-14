extends Node
class_name CombatManager 

signal Combat_Happened
signal Selected_Character_Changed(new_selected_character)
signal Selected_NPC_Changed(new_selected_NPC)
signal Heal_Character
signal Combat_Action(action)
signal Randomly_Target
signal Player_Targeted
enum COMBAT_ACTION{
	Mele,
	Ranged,
	Block,
	Heal,
	HealNPC,
	MeleNPC
	}

var selected_character
var selected_NPC
var targeted_character

func _init():
	connect("Combat_Action",self,"combat_action")
	connect("Selected_Character_Changed",self,"selected_character_changed")
	connect("Selected_NPC_Changed",self,"selected_NPC_changed")
	connect("Player_Targeted",self,"target_player_changed")


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
		"HealNPC":
			healing_points = 4
		"MeleNPC":
			weapon_damage = 6
			chanceToHit += 0
	
	randomize()
	
	if action == "Block":
		selected_character.block(defence_bonus)
		print("Your Action: %s" % action)
	elif action == "Heal":
		selected_character.heal(healing_points)
		selected_character.stop_block()
		print("Your Action: %s Healing Points: %s" % [action,healing_points])
	elif action == "HealNPC":
		selected_NPC.heal(healing_points)
		print("Enemy Action: %s Healing Points: %s" % [action,healing_points])
	else:
		var toHitRoll = (randi() % 20) + 1
		var damage = 0
		if action == "MeleNPC":
			chanceToHit += selected_character.defence_bonus
		else:
			selected_character.stop_block()
		if (toHitRoll >= chanceToHit):
			damage = (randi() % weapon_damage) + 1 # d8
		if action == "MeleNPC":
			print("NPC Action: %s Roll: %s/%s Damage : %s" % [action,toHitRoll,chanceToHit,damage])
			targeted_character.take_damage(damage)
		else:
			print("Your Action: %s Roll: %s/%s Damage : %s" % [action,toHitRoll,chanceToHit,damage])
			selected_NPC.take_damage(damage)
		emit_signal("Combat_Happened",damage)


#Called by signals
func combat_action(action):
	if action == "Target":
		emit_signal("Randomly_Target")
	else:
		perform_combat_action(action,selected_character)


#Called by signals
func selected_character_changed(new_selected_character):
	selected_character = new_selected_character#Called by signals

func selected_NPC_changed(new_selected_NPC):
	selected_NPC = new_selected_NPC


func target_player_changed(new_targeted_character):
	targeted_character = new_targeted_character

