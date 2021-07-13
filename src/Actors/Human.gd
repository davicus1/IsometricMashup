extends Actor


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

func _ready():
	#BAD CODE HERE
	status_overlay = myCamera.get_child(0)
	status_overlay._actor_to_watch(self)
	####
	if gamestate.is_single_player || is_network_master():
		myCamera.make_current()
	
	animationTree.set("parameters/Idle/blend_position", actionDirection)
	animationTree.set("parameters/Run/blend_position", actionDirection)
	animationTree.set("parameters/Pickup/blend_position", actionDirection)


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


func _on_InteractionArea_area_shape_entered(area_id: int, area: Area2D, area_shape: int, local_shape: int) -> void:
	on_InteractionArea_area_shape_entered(area_id, area, area_shape, local_shape)

func _on_InteractionArea_area_shape_exited(area_id: int, area: Area2D, area_shape: int, local_shape: int) -> void:
	on_InteractionArea_area_shape_exited(area_id, area, area_shape, local_shape)
