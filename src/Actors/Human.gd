extends Actor

##TODO Duplicate Code from Troll
const MOTION_SPEED = 160 * 60 # Pixels/second.

#puppet var puppet_pos = Vector2()
puppet var puppet_motion = Vector2()

enum PlayerState{
	MOVE,
	PICKUP
}

var state = PlayerState.MOVE
var motion = Vector2.ZERO
var actionDirection = Vector2.DOWN #intention is this is southeast

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animatedSprite = $AnimatedSprite
onready var animationState = animationTree.get("parameters/playback")

#A prototype HU-MAAN. 
func _init():
	health_max = 10
	health_current = 10
	capacity = Capacity.new(50,100,20)
	inventory = Inventory.new()
	inventory.add(ItemRock.new().construct())

func _ready():
	if gamestate.is_single_player || is_network_master():
		$Camera2D.make_current()
	animationTree.set("parameters/Idle/blend_position", actionDirection)
	animationTree.set("parameters/Run/blend_position", actionDirection)
	animationTree.set("parameters/Pickup/blend_position", actionDirection)
	
func _physics_process(delta):
	match state:
		PlayerState.MOVE:
			moveState(delta)
		PlayerState.PICKUP:
			pickupState(delta)

func moveState(delta):
	if gamestate.is_single_player || is_network_master():
		motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		motion.y *= 0.5
		if motion != Vector2.ZERO:
			actionDirection = motion.normalized()
			var speed = MOTION_SPEED
			if Input.is_action_pressed("Run"):
				speed *= 3
				animatedSprite.speed_scale = 1
				animationState.travel("Run")
			else:
				animatedSprite.speed_scale = .3
				animationState.travel("Walk")
			motion = actionDirection * speed * delta
		else:
			animatedSprite.speed_scale = 1
			animationState.travel("Idle")
		animationTree.set("parameters/Idle/blend_position", actionDirection)
		animationTree.set("parameters/Run/blend_position", actionDirection)
		animationTree.set("parameters/Walk/blend_position", actionDirection)
		animationTree.set("parameters/Pickup/blend_position", actionDirection)
		#Send Network position
		#TODO check actionDirection animations for multiplayer
		if not gamestate.is_single_player:
			rset("puppet_motion", motion)
		#rset("puppet_pos", position)
	else:
		#position = puppet_pos
		motion = puppet_motion
		
	#warning-ignore:return_value_discarded
	move_and_slide(motion)
	if Input.is_action_just_pressed("Pickup"):
		animatedSprite.speed_scale = 1
		state = PlayerState.PICKUP
	
	#if not is_network_master():
	#	puppet_pos = position # To avoid jitter (TODO see this in action, copied from bomber)

func pickupState(_delta):
	motion = Vector2.ZERO
	animationState.travel("Pickup")

func pickupAnimationFinished():
	state = PlayerState.MOVE

func set_player_name(new_name):
	character_name = new_name
	get_node("Name").set_text(new_name)


func _on_InteractionArea_area_shape_entered(area_id, area:Area2D, area_shape, self_shape):
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

func _on_InteractionArea_area_shape_exited(area_id, area, area_shape, self_shape):
	#TODO this seems brittle
	var owner = area.get_parent()
	if owner is Item:
		if owner.collectable:
			_collectable_item_not_in_reach(owner)
