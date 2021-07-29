extends Actor


onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")


#A prototype HU-MAAN. 
func _init():
	health_max = 10
	health_current = 10
	capacity = Capacity.new(50,100,20)


func _ready():
	manipulate_animation_player()
	callBlendPosition(actionDirection)


func callBlendPosition(theActionDirection):
	animationTree.set("parameters/Idle/blend_position", theActionDirection)
	animationTree.set("parameters/Run/blend_position", theActionDirection)
	animationTree.set("parameters/Pickup/blend_position", theActionDirection)


func doAnimationPickup():
	animationState.travel("Pickup")


func doAnimationRun():
	animationState.travel("Run")


func doAnimationIdle():
	animationState.travel("Idle")


func manipulate_animation_player():
	var sprite_node:AnimatedSprite = get_node(character_type)
	for animationName in animationPlayer.get_animation_list():
		var animation:Animation = animationPlayer.get_animation(animationName)
		animation.track_set_path(0, NodePath(character_type + ":animation"))
		sprite_node.show()


func pickupAnimationFinished():
	state = PlayerState.MOVE
	#TODO Is this the right way to fix the client seeing the host continuing to pickup twice?
	if not gamestate.is_single_player && is_network_master():
		rset("puppet_state", state)
	pickup_next_item()

