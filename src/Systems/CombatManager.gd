extends Node

signal Combat_Happened
enum COMBAT_ACTION{
	Mele,
	Ranged,
	Block,
	Heal
	}
	
func combat_action(action):
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
		print("Your Action: %s Healing Points: %s" % [action,healing_points])
	else:
		var toHitRoll = (randi() % 20) + 1
		var damage = 0
		if (toHitRoll >= chanceToHit):
			damage = (randi() % weapon_damage) + 1 # d8
		print("Your Action: %s Roll: %s/%s Damage : %s" % [action,toHitRoll,chanceToHit,damage])
		emit_signal("Combat_Happened",damage)


