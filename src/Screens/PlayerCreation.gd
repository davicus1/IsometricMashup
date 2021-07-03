extends Control

onready var name_label = $Name
onready var name_field = $Name/NameField
onready var class_label = $Class
onready var class_list = $Class/ClassList

func _ready():
	name_field.text = gamestate.player_name
	var selected_index = 0
	var index = 0
	for a_class in gamestate.classes:
		class_list.add_item(a_class, null, true)
		if a_class == gamestate.player_class:
			selected_index = index
		index += 1
	class_list.select(selected_index, true)

func update_player_name():
	gamestate.player_name = name_field.text

func update_player_class():
	var array_of_selected_item_positions = class_list.get_selected_items()
	if not array_of_selected_item_positions.empty():
		var the_selected_item = array_of_selected_item_positions[0]
		gamestate.player_class = class_list.get_item_text(the_selected_item)
