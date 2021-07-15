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
	pickup_next_item()


func _on_InteractionArea_area_shape_entered(area_id: int, area: Area2D, area_shape: int, local_shape: int) -> void:
	on_InteractionArea_area_shape_entered(area_id, area, area_shape, local_shape)

func _on_InteractionArea_area_shape_exited(area_id: int, area: Area2D, area_shape: int, local_shape: int) -> void:
	on_InteractionArea_area_shape_exited(area_id, area, area_shape, local_shape)
