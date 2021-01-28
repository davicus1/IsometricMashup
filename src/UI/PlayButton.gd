tool
extends Button

export(String,FILE) var next_scene_path: = ""


func _on_PlayButton_button_up():
	get_tree().change_scene(next_scene_path)
	get_tree().paused = false

func _get_configuration_warning():
	return "next_scene_path must be set for the button to work" if next_scene_path == "" else ""


func _on_SinglePlayer_Button_pressed():
	gamestate.single_player_game()
