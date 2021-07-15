extends Actor


#A prototype Troll. 
func _init():
	health_max = 20
	health_current = 20
	capacity = Capacity.new(50,100,20)

func _ready():
	pass


func pickupState(delta):
	state = PlayerState.MOVE
	if not gamestate.is_single_player:
		rset("puppet_state", state)
	pickup_next_item()

