extends Control

onready var options = $OptionsScreen



func _on_OptionsButton_pressed():
	options.visible = true


func _on_SinglePlayerChangeSceneButton_button_down():
	gamestate.is_single_player = true
