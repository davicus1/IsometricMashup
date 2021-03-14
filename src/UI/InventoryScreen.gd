extends Control

onready var player = gamestate.local_player_character


func _ready():
	for item in player.inventory.items:
		$InventoryItemList.add_item(item.item_name, item.icon, true)

func _refresh_items_in_location():
	$InLocationItemList.clear()
	for item in player.collectable_items_in_reach:
		$InLocationItemList.add_item(item.item_name, item.icon, true)
