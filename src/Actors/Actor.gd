extends KinematicBody2D
class_name Actor

const MOTION_SPEED = 160 * 60 # Pixels/second.

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
onready var myCamera = $PlayerCameraInterface
onready var status_overlay:ActorStatusOverlay = $PlayerCameraInterface/ActorStatusOverlay
onready var nameLabel = $Name
onready var stashStuff = $StashStuff

var collectable_items_in_reach:Array = []
var character_type:String

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
	status_overlay._actor_to_watch(self)
	if gamestate.is_single_player || is_network_master():
		myCamera.make_current()
	nameLabel.set_text(character_name)


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


func set_character_type(new_character_type:String):
	character_type = new_character_type


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
		print("Collectible " + collectable.name + " Owner " + collectable.owner.name)
		collectable.get_parent().remove_child(collectable)
		inventory.add(collectable)
		stashStuff.add_child(collectable)
		collectable.set_owner(self)
		if collectable.owner != null:
			print("Owner is now " + collectable.owner.name)


#func _build_animated_sprite(character_race:String, character_gender:String, character_model:String):
#	var animatedSprite:AnimatedSprite = null
#	var animation_names = ["Idle-E", "Pickup-NW"]
#	for animation in animation_names:
#		animatedSprite.frames.add_animation(animation)
#		var texturepath = "res://basePath/" + character_race + "/" + character_gender + "/" + character_model + "_" + animation + "_" + direction
#		animatedSprite.frames.add_frame(animation,)
