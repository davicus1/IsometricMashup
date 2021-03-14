extends Item
class_name ItemRock
func _ready():
	construct()

func construct():
	if not _constructed:
		scene_for_item = load("res://src/Objects/item_rock.tscn").instance()
		icon = load("res://Assets/objects/rock.png")
		collectable = true
		mass = 1.0
		volume = 5.0
		health_max = 10
		health_current = 10
		item_name = "Rock"
		item_description = "Solid Granite Rock"
		equipment = Equipment.new()
		equipment.one_handed_weapon = true
		stackable = true
		stack_current = 1
		stack_max = 3
	_constructed = true
	return self
