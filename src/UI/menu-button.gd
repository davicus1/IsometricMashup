extends Button

export var reference_path = ""
export(bool) var start_focused = false
export(bool) var quit_button = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if(start_focused):
		grab_focus()
		
	
# warning-ignore:return_value_discarded
	connect("mouse_entered",self,"_on_Button_mouse_entered")
# warning-ignore:return_value_discarded
	connect("pressed",self,"_on_Button_pressed")

func _on_Button_mouse_entered():
	grab_focus()
	
func _on_Button_pressed():
	if(reference_path != ""):
		var change_scene_result = get_tree().change_scene(reference_path)
		if change_scene_result != OK:
			printerr ("Failed to change scene to next scene path " + reference_path)
		get_tree().quit(0)
	
