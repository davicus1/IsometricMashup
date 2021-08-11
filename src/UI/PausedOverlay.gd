extends ColorRect

onready var scene_tree: = get_tree()
onready var ui_title: Label = get_node("Title")
onready var options = $OptionsScreen

const DIED_MESSAGE: = "You Died! :("
var paused: = false setget set_paused


func _ready():
# warning-ignore:return_value_discarded
	gamestate.connect("player_died", self, "_on_PlayerData_player_died")
# warning-ignore:return_value_discarded
	gamestate.connect("paused_state_changed", self, "_react_to_paused_set_change")

func _react_to_paused_set_change():
	update_menu()
	self.visible = paused

func set_paused(value: bool):
	gamestate.pause_game_all(value)



func _unhandled_input(event):
	if event.is_action_pressed("pause") and ui_title.text != DIED_MESSAGE:
		set_paused(not scene_tree.paused)
		scene_tree.set_input_as_handled()
	elif event.is_action_pressed("menu"):
		update_menu()
		self.visible = not self.visible
		scene_tree.set_input_as_handled()


func update_menu():
	paused = scene_tree.paused
	if paused:
		ui_title.text = "Paused"
	else:
		ui_title.text = "Menu"


func _on_PlayerData_player_died():
	#self.paused = true
	ui_title.text = DIED_MESSAGE


func _on_OptionsButtion_pressed():
	options.visible = true


func _on_PauseButton_pressed():
	set_paused(not paused)


func _on_BackToGameButton_pressed():
	self.visible = not self.visible
