extends Button
class_name CombatActivityButton

export var combat_action:String = "Default"

var my_combat_screen


func _on_CombatActivityButton_pressed():
	combatmanager.combat_action(combat_action,my_combat_screen.selectedPlayer)
	
	
func set_combat_screen_callback(combat_screen):
	my_combat_screen = combat_screen
