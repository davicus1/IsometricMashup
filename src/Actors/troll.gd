extends KinematicBody2D

const MOTION_SPEED = 160 * 60 # Pixels/second.

#puppet var puppet_pos = Vector2()
puppet var puppet_motion = Vector2()

func _ready():
	if gamestate.is_single_player || is_network_master():
		$Camera2D.make_current()
	
	
func _physics_process(delta):
	var motion = Vector2()
	if gamestate.is_single_player || is_network_master():
		motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		motion.y *= 0.5
		motion = motion.normalized() * MOTION_SPEED * delta
		
		#Send Network position
		if not gamestate.is_single_player:
			rset("puppet_motion", motion)
		#rset("puppet_pos", position)
	else:
		#position = puppet_pos
		motion = puppet_motion
		
	#warning-ignore:return_value_discarded
	move_and_slide(motion)
	
	#if not is_network_master():
	#	puppet_pos = position # To avoid jitter (TODO see this in action, copied from bomber)

func set_player_name(new_name):
	get_node("Name").set_text(new_name)
