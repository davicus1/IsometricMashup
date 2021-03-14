extends Actor

const MOTION_SPEED = 160 * 60 # Pixels/second.

#puppet var puppet_pos = Vector2()
puppet var puppet_motion = Vector2()

#A prototype Troll. 
func _init():
	health_max = 20
	health_current = 20
	capacity = Capacity.new(50,100,20)
	inventory = Inventory.new()
	inventory.add(ItemRock.new().construct())

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
