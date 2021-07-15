extends Actor


onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animatedSprite = $AnimatedSprite
onready var animationState = animationTree.get("parameters/playback")


#A prototype HU-MAAN. 
func _init():
	health_max = 10
	health_current = 10
	capacity = Capacity.new(50,100,20)


func _ready():
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


func pickupAnimationFinished():
	state = PlayerState.MOVE
	#TODO Is this the right way to fix the client seeing the host continuing to pickup twice?
	rset("puppet_state", state)
	pickup_next_item()

