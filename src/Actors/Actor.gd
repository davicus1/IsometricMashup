extends KinematicBody2D
class_name Actor

var health_current:int
var health_max:int
var mass:float
var volume:float
var inventory:Inventory
var capacity:Capacity
var character_name:String

var collectable_items_in_reach:Array = []

func _ready():
	pass

func on_InteractionArea_area_shape_entered(area_id, area:Area2D, area_shape, self_shape):
	#TODO Why does this not work when the docs say this is how you find it!????
	#var obj2 = shape_owner_get_owner(shape_find_owner(area_id))
	
	#TODO this seems brittle
	var owner = area.get_parent()
	if owner is Item:
		if owner.collectable:
			_collectable_item_in_reach(owner)

func _collectable_item_in_reach(item:Item):
	collectable_items_in_reach.append(item)

func _collectable_item_not_in_reach(item:Item):
	collectable_items_in_reach.erase(item)

func on_InteractionArea_area_shape_exited(area_id, area, area_shape, self_shape):
	#TODO this seems brittle
	var owner = area.get_parent()
	if owner is Item:
		if owner.collectable:
			_collectable_item_not_in_reach(owner)

func pickup_next_item():
	var collectable = collectable_items_in_reach.pop_back()
	inventory.add(collectable)
