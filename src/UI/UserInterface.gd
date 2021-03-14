extends Control

onready var scene_tree: = get_tree()
onready var pause_overlay: ColorRect = get_node("PausedOverlay")
onready var health: Label = get_node("Health")
onready var ui_title: Label = get_node("PausedOverlay/Title")
onready var inventory_screen = $Inventory

const DIED_MESSAGE: = "You Died! :("
var paused: = false setget set_paused
var inventory_visible: = false

func _ready():
	gamestate.connect("health_updated", self, "update_interface")
	gamestate.connect("player_died", self, "_on_PlayerData_player_died")
	update_interface()
	
func set_paused(value: bool):
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value

func _unhandled_input(event):
	if event.is_action_pressed("pause") and ui_title.text != DIED_MESSAGE:
		self.paused = not paused
		scene_tree.set_input_as_handled()
	elif event.is_action_pressed("inventory"):
		show_hide_inventory()
		scene_tree.set_input_as_handled()

func show_hide_inventory():
	inventory_visible = not inventory_visible
	if inventory_visible:
		inventory_screen._refresh_items_in_location()
	inventory_screen.visible = inventory_visible
	
func update_interface():
	health.text = "Health %s / %s" % [gamestate.local_player_character.health_current, gamestate.local_player_character.health_max]

func _on_PlayerData_player_died():
	self.paused = true
	ui_title.text = DIED_MESSAGE
