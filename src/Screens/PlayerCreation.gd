extends Control

onready var name_label = $Name
onready var name_field = $Name/NameField
onready var class_label = $Class
onready var class_list = $Class/ClassList
onready var character_list = $Character/CharacterList

func _ready():
	name_field.text = gamestate.get_player_name()
	var selected_index = 0
	var index = 0
	for a_class in gamestate.classes:
		class_list.add_item(a_class, null, true)
		if a_class == gamestate.get_player_class():
			selected_index = index
		index += 1
	class_list.select(selected_index, true)
	#Choose your character look
	selected_index = 0
	index = 0
	for a_character in gamestate.characters:
		character_list.add_item(a_character, null, true)
		if a_character == gamestate.get_player_character():
			selected_index = index
		index += 1
	character_list.select(selected_index, true)


func update_player_name():
	gamestate.local_player_info.player_name = name_field.text

func update_player_class():
	var array_of_selected_item_positions = class_list.get_selected_items()
	if not array_of_selected_item_positions.empty():
		var the_selected_item = array_of_selected_item_positions[0]
		gamestate.local_player_info.player_class = class_list.get_item_text(the_selected_item)

func update_player_character():
	var array_of_selected_item_positions = character_list.get_selected_items()
	if not array_of_selected_item_positions.empty():
		var the_selected_item = array_of_selected_item_positions[0]
		gamestate.local_player_info.player_character = character_list.get_item_text(the_selected_item)
