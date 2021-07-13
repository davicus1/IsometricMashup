extends KinematicBody2D
class_name Actor

const MOTION_SPEED = 160 * 60 # Pixels/second.

#puppet var puppet_pos = Vector2()
puppet var puppet_motion = Vector2.ZERO
puppet var puppet_direction = Vector2.DOWN
puppet var puppet_running = false
puppet var puppet_state = PlayerState.MOVE
puppet var puppet_position = Vector2.ZERO

var health_current:int
var health_max:int
var mass:float
var volume:float
var inventory:Inventory
var capacity:Capacity
var character_name:String
var status_overlay:ActorStatusOverlay

var collectable_items_in_reach:Array = []

enum PlayerState{
	MOVE,
	PICKUP
}

var state = PlayerState.MOVE
var motion = Vector2.ZERO
var actionDirection = Vector2.DOWN #intention is this is southeast


func _init():
	inventory = Inventory.new()


func _ready():
	pass


func _physics_process(delta):
	match state:
		PlayerState.MOVE:
			moveState(delta)
		PlayerState.PICKUP:
			pickupState(delta)


func moveState(delta):
	pass


func pickupState(delta):
	pass


func set_player_name(new_name):
	character_name = new_name
	get_node("Name").set_text(new_name)


func on_InteractionArea_area_shape_entered(area_id, area:Area2D, _area_shape, _self_shape):
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


func on_InteractionArea_area_shape_exited(area_id, area, _area_shape, _self_shape):
	#TODO this seems brittle
	var owner = area.get_parent()
	if owner is Item:
		if owner.collectable:
			_collectable_item_not_in_reach(owner)


func pickup_next_item():
	var collectable:Item = collectable_items_in_reach.pop_back()
	if collectable != null:
		collectable.get_parent().remove_child(collectable)
		inventory.add(collectable)


func connect_to_status_overlay():
	print("connect_to_status_overlay " )
	#actor_status_overlay.it_is_me(self)
