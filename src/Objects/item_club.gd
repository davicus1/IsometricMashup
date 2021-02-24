extends Item


func _ready():
	collectable = true
	mass = 5.0
	volume = 15.0
	health_max = 100
	health_current = 100
	item_name = "Oak Club"
	item_description = "A sturdy, if primative weapon, the Oak Club will last hundreds of bashings"
	equipment = Equipment.new()
	equipment.hand_equipable = true
	
	
