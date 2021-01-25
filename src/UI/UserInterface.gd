extends Control

onready var scene_tree: = get_tree()
onready var pause_overlay: ColorRect = get_node("PausedOverlay")
onready var score: Label = get_node("Score")
onready var ui_title: Label = get_node("PausedOverlay/Title")

const DIED_MESSAGE: = "You Died! :("
var paused: = false setget set_paused

func _ready():
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	update_interface()
	
func set_paused(value: bool):
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value

func _unhandled_input(event):
	if event.is_action_pressed("pause") and ui_title.text != DIED_MESSAGE:
		self.paused = not paused
		scene_tree.set_input_as_handled()

func update_interface():
	score.text = "Score %s" % PlayerData.score

func _on_PlayerData_player_died():
	self.paused = true
	ui_title.text = DIED_MESSAGE
