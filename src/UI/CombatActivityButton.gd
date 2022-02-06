extends Button
class_name CombatActivityButton

export var combat_action:String = "Default"




func _on_CombatActivityButton_pressed():
	combatmanager.combat_action(combat_action)
	
