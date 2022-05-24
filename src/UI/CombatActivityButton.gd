extends Button
class_name CombatActivityButton

export var combat_action:String = "Default"


func _on_CombatActivityButton_pressed():
	combatmanager.emit_signal("Combat_Action",combat_action)

