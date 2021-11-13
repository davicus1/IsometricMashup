extends Control

onready var player = gamestate.local_player_character
onready var scene_tree: = get_tree()
onready var inventory_screen = self

var inventory_visible: = false

func _ready():
	#for item in player.inventory.items:
	#	$InventoryItemList.add_item(item.item_name, item.icon, true)
	pass

func _refresh_items_in_location():
	$InLocationItemList.clear()
	for item in player.collectable_items_in_reach:
		$InLocationItemList.add_item(item.item_name, item.icon, true)

func _refresh_items_in_inventory():
	$InventoryItemList.clear()
	for item in player.inventory.items:
		$InventoryItemList.add_item(item.item_name, item.icon, true)

func refresh_inventory():
	_refresh_items_in_location()
	_refresh_items_in_inventory()


func _unhandled_input(event):
	if event.is_action_pressed("inventory") && player != null && (gamestate.is_single_player || is_network_master()):
		show_hide_inventory()
		scene_tree.set_input_as_handled()


func show_hide_inventory():
	inventory_visible = not inventory_visible
	if inventory_visible:
		inventory_screen.refresh_inventory()
	inventory_screen.visible = inventory_visible
