extends ColorRect

onready var scene_tree: = get_tree()
onready var ui_title: Label = get_node("Title")
onready var options = $OptionsScreen

const DIED_MESSAGE: = "You Died! :("
var paused: = false setget set_paused


func _ready():
	gamestate.connect("player_died", self, "_on_PlayerData_player_died")
	
func set_paused(value: bool):
	paused = value
	scene_tree.paused = value
	self.visible = value
	if paused:
		ui_title.text = "Paused"
	else:
		ui_title.text = "Menu"
	

func _unhandled_input(event):
	if event.is_action_pressed("pause") and ui_title.text != DIED_MESSAGE:
		self.paused = not paused
		scene_tree.set_input_as_handled()
	elif event.is_action_pressed("menu"):
		self.visible = not self.visible
		scene_tree.set_input_as_handled()



func _on_PlayerData_player_died():
	#self.paused = true
	ui_title.text = DIED_MESSAGE


func _on_OptionsButtion_pressed():
	options.visible = true


func _on_PauseButton_pressed():
	self.paused = not paused


func _on_BackToGameButton_pressed():
	self.visible = not self.visible
