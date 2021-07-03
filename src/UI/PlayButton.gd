tool
extends Button

export(String,FILE) var next_scene_path: = ""


func _on_PlayButton_button_up():
	if next_scene_path:
		var change_scene_result = get_tree().change_scene(next_scene_path)
		if change_scene_result != OK:
			printerr ("Failed to change scene to next scene path " + next_scene_path)
		get_tree().paused = false

func _get_configuration_warning():
	return "next_scene_path must be set for the button to work" if next_scene_path == "" else ""


func _on_PlayButton_pressed():
	gamestate.begin_game()
