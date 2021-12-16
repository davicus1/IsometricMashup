extends Polygon2D
class_name DialogBox

onready var label:RichTextLabel = $RichTextLabel
onready var timer = $Timer

var pages_of_dialog = ["Hiya! How are you?", 
"Industrial versus Medieval Conflict\n" \
+ "Tech Runs to find supplies\n" \
+ "Intro to Cloud City/3-4D Printer (Not accessible right away)\n"\
+ "Captured by Security Bots, thrown in Jail (that no longer operates but bots still use it as they were programmed). Have to figure out how to escape or be rescued.\n"\
+ "Weave in technomages: brief encounters, being in awe of them. Get noticed when your technology advances. They request your services.\n"\
+ "Discovery/Creation of 1st Airship Port. (In the mountains: Mt Shasta/Mt. Rainier/Mesa/Canyon/Canada/Maine) Maybe there's skyscrapers in New York. Made up mountains due to the geographical changes."]
var page = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	label.visible_characters = 0
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("Talk") && not visible:
		popup(pages_of_dialog)
	elif event.is_action_pressed("Talk") || (event.is_action_pressed("ui_select")):
		if label.visible_characters >= label.get_total_character_count():
			label.visible_characters = 0
			if page < pages_of_dialog.size() - 1:
				page += 1
				label.bbcode_text = pages_of_dialog[page]
			else:
				hide_dialog_box()
		else:
			label.visible_characters = label.get_total_character_count()


func _on_Timer_timeout():
	label.visible_characters += 1

func hide_dialog_box():
	timer.stop()
	visible = false

func popup(new_dialog):
	pages_of_dialog = new_dialog
	if not visible:
		page = 0
		label.visible_characters = 0
		label.bbcode_text = pages_of_dialog[page]
		visible = true
		timer.start()
