extends Actor


#A prototype Troll. 
func _init():
	health_max = 20
	health_current = 20
	capacity = Capacity.new(50,100,20)

func _ready():
	pass


func pickupState(delta):
	#print(character_name + PlayerState.keys()[state])
	pickup_next_item()
	#TODO maybe pickup_next_item needs to be redone as a remote or synchronous method because we are
	#relying on the state change from being picked up in the physics process by the client to actually
	#execute the state change
	state = PlayerState.MOVE
	if not gamestate.is_single_player && is_network_master():
		rset("puppet_state", state)
	

