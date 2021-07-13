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
	pickup_next_item()


func _on_InteractionArea_area_shape_entered(area_id: int, area: Area2D, area_shape: int, local_shape: int) -> void:
	on_InteractionArea_area_shape_entered(area_id, area, area_shape, local_shape)

func _on_InteractionArea_area_shape_exited(area_id: int, area: Area2D, area_shape: int, local_shape: int) -> void:
	on_InteractionArea_area_shape_exited(area_id, area, area_shape, local_shape)
