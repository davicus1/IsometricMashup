extends Actor

##TODO Duplicate Code from Troll
const MOTION_SPEED = 160 * 60 # Pixels/second.

#puppet var puppet_pos = Vector2()
puppet var puppet_motion = Vector2.ZERO
puppet var puppet_direction = Vector2.DOWN
puppet var puppet_running = false
puppet var puppet_state = PlayerState.MOVE
puppet var puppet_position = Vector2.ZERO


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
onready var myCamera = $PlayerCameraInterface

#A prototype HU-MAAN. 
func _init():
	health_max = 10
	health_current = 10
	capacity = Capacity.new(50,100,20)
	inventory = Inventory.new()
	inventory.add(ItemRock.new().construct())

func _ready():
	if gamestate.is_single_player || is_network_master():
		myCamera.make_current()
	
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
	var running = false
	if gamestate.is_single_player || is_network_master():
		motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		motion.y *= 0.5
		running = Input.is_action_pressed("Run")
		if Input.is_action_just_pressed("Pickup"):
			state = PlayerState.PICKUP
			animationState.travel("Pickup")
		
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
		
	animationTree.set("parameters/Idle/blend_position", actionDirection)
	animationTree.set("parameters/Run/blend_position", actionDirection)
	animationTree.set("parameters/Pickup/blend_position", actionDirection)
	if motion != Vector2.ZERO:
		actionDirection = motion.normalized()
		var speed = MOTION_SPEED
		if running:
			speed *= 3
		animationState.travel("Run")
		motion = actionDirection * speed * delta
	else:
		animationState.travel("Idle")
		
	#Send Network position
	#TODO check actionDirection animations for multiplayer

		
	#warning-ignore:return_value_discarded
	move_and_slide(motion)
	
	#if not is_network_master():
	#	puppet_pos = position # To avoid jitter (TODO see this in action, copied from bomber)

func pickupState(_delta):
	motion = Vector2.ZERO
	animationState.travel("Pickup")

func pickupAnimationFinished():
	state = PlayerState.MOVE
	pickup_next_item()

func set_player_name(new_name):
	character_name = new_name
	get_node("Name").set_text(new_name)

func _on_InteractionArea_area_shape_entered(area_id: int, area: Area2D, area_shape: int, local_shape: int) -> void:
	on_InteractionArea_area_shape_entered(area_id, area, area_shape, local_shape)

func _on_InteractionArea_area_shape_exited(area_id: int, area: Area2D, area_shape: int, local_shape: int) -> void:
	on_InteractionArea_area_shape_exited(area_id, area, area_shape, local_shape)
