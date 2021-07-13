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
	var running = false
	if gamestate.is_single_player || is_network_master():
		motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		motion.y *= 0.5
		running = Input.is_action_pressed("Run")
		if Input.is_action_just_pressed("Pickup"):
			state = PlayerState.PICKUP
		
		if not gamestate.is_single_player:
			rset("puppet_motion", motion)
			rset("puppet_direction", actionDirection)
			rset("puppet_running", running)
			rset("puppet_state", state)
			rset("puppet_position", position)
	else:
		motion = puppet_motion
		actionDirection = puppet_direction
		running = puppet_running
		state = puppet_state
		position = puppet_position
	callBlendPosition(actionDirection)
	
	if motion != Vector2.ZERO:
		actionDirection = motion.normalized()
		var speed = MOTION_SPEED
		if running:
			speed *= 3
		motion = actionDirection * speed * delta
		doAnimationRun()
	else:
		doAnimationIdle()
	#warning-ignore:return_value_discarded
	move_and_slide(motion)

func doAnimationPickup():
	pass


func doAnimationRun():
	pass


func doAnimationIdle():
	pass


func callBlendPosition(theActionDirection):
	pass


func pickupState(_delta):
	motion = Vector2.ZERO
	doAnimationPickup()


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
