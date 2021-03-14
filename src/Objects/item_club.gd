extends Item
class_name ItemClub

func _ready():
	construct()

func construct():
	if not _constructed:
		scene_for_item = load("res://src/Objects/item_club.tscn").instance()
		icon = load("res://Assets/objects/club.png")
		collectable = true
		mass = 5.0
		volume = 15.0
		health_max = 100
		health_current = 100
		item_name = "Oak Club"
		item_description = "A sturdy, if primative weapon, the Oak Club will last hundreds of bashings"
		equipment = Equipment.new()
		equipment.one_handed_weapon = true
	_constructed = true
	return self
