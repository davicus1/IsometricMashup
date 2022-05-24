extends KinematicBody2D
class_name Actor

const MOTION_SPEED = 160 * 60 # Pixels/second.

signal health_updated

puppet var puppet_motion = Vector2.ZERO
puppet var puppet_direction = Vector2.DOWN
puppet var puppet_running = false
puppet var puppet_state = PlayerState.MOVE
puppet var puppet_position = Vector2.ZERO
puppet var puppet_inConversation = false
puppet var puppet_dialog = ""

var health_current:int setget set_health_current
var health_max:int setget set_health_max
var mass:float
var volume:float
var inventory:Inventory
var capacity:Capacity
remote var inConversation = false
var hadInitialConversation = false
var currentDialog = ""
export var character_name:String
onready var myCamera = $PlayerCameraInterface
onready var status_overlay:ActorStatusOverlay = $PlayerCameraInterface/ActorStatusOverlay

onready var nameLabel = $Name
onready var stashStuff = $StashStuff
onready var promptChat = $PromptChat
onready var ray = $RayCast2D
const RAY_CAST_SIZE:float = 250.0

var collectable_items_in_reach:Array = []
export var character_type:String

export(bool) var playerControlled = true

var automotion = 0

enum PlayerState{
	MOVE,
	PICKUP,
	CONVERSATION
}

var state = PlayerState.MOVE
var motion = Vector2.ZERO
var actionDirection = Vector2.DOWN #intention is this is southeast


func _init():
	inventory = Inventory.new()


func _ready():
	status_overlay._actor_to_watch(self)
	if playerControlled:
		if gamestate.is_single_player || is_network_master():
			myCamera.make_current()
	nameLabel.set_text(character_name)
	ray.cast_to = actionDirection * RAY_CAST_SIZE


func _physics_process(delta):
	match state:
		PlayerState.MOVE:
			moveState(delta)
		PlayerState.PICKUP:
			pickupState(delta)
		PlayerState.CONVERSATION:
			conversationState(delta)
	


func moveState(delta):
	var running = false
	if playerControlled:
		if gamestate.is_single_player || is_network_master():
			motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
			motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
			motion.y *= 0.5
			running = Input.is_action_pressed("Run")
			if Input.is_action_just_pressed("Pickup"):
				state = PlayerState.PICKUP
			if Input.is_action_just_pressed("Heal"):
				set_health_current(health_current +1)
	else:
		if automotion >= 0 && automotion < 120:
			motion.x = 1.0
			automotion += 1
		elif automotion == 120:
			automotion = -121
		else: 
			motion.x = -1.0
			automotion += 1
			
	if not gamestate.is_single_player: 
		if is_network_master():
			#rset("puppet_state", state)
			###TO DO: update NPC movements in multiplayer
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
	
	callBlendPosition(actionDirection)
	
	if motion != Vector2.ZERO:
		actionDirection = motion.normalized()
		var speed = MOTION_SPEED
		if running:
			speed *= 3
		motion = actionDirection * speed * delta
		ray.cast_to = actionDirection * RAY_CAST_SIZE
		ray.force_raycast_update() #TO DO Should this be forced?
		spot_something()
		doAnimationRun()
	else:
		doAnimationIdle()
	#warning-ignore:return_value_discarded
	move_and_slide(motion)

func spot_something():
	if ray.is_colliding():
		var collider = ray.get_collider()
		print(self.character_name + " See " + collider.name)
		if collider.character_name == "Marselle":
			currentDialog = "I see you Marselle!"
			promptChat.text = currentDialog
			promptChat.visible = true
	else: 
		promptChat.visible = false

func conversationState(delta):
	doAnimationIdle()
	if gamestate.is_single_player || is_network_master():
		if not inConversation:
			state = PlayerState.MOVE
			promptChat.hide()
		if not gamestate.is_single_player:
			rset("puppet_inConversation", inConversation)
			rset("puppet_state", state)
			rset("puppet_dialog", currentDialog)
	else:
		inConversation = puppet_inConversation
		state = puppet_state
		currentDialog = puppet_dialog
		promptChat.text = currentDialog
		promptChat.visible = inConversation
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		inConversation = false
		if not gamestate.is_single_player && not is_network_master():
			rset_id(1, "inConversation", false)



func doPromptChat(theDialog):
	currentDialog = theDialog
	inConversation = true
	state = PlayerState.CONVERSATION
	promptChat.text = currentDialog
	promptChat.show()



func doAnimationPickup():
	do_pickup()


func doAnimationRun():
	pass


func doAnimationIdle():
	pass


func callBlendPosition(_theActionDirection):
	pass


func pickupState(_delta):
	motion = Vector2.ZERO
	doAnimationPickup()
	


func set_player_name(new_name):
	character_name = new_name


func set_character_type(new_character_type:String):
	character_type = new_character_type

func set_health_current(new_health):
	health_current = new_health
	emit_signal("health_updated")


func set_health_max(new_max):
	health_max = new_max
	emit_signal("health_updated")


func on_PerformActionArea_area_shape_entered(area_id, area:Area2D, _area_shape, _self_shape):
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


func on_PerformActionArea_area_shape_exited(area_id, area, _area_shape, _self_shape):
	#TODO this seems brittle
	var owner = area.get_parent()
	if owner is Item:
		if owner.collectable:
			_collectable_item_not_in_reach(owner)


func do_pickup():
		#print_debug(character_name + PlayerState.keys()[state])
	#pickup_next_item is now a remotesync method to not rely on the state change
	# from being picked up in the physics process by the client in time to actually
	#execute the state change on all the clients and pick up the item. This forces 
	#the clients to pick up the item even if the state change happened too fast
	if gamestate.is_single_player:
		pickup_next_item()
	elif is_network_master():
		rpc("pickup_next_item")
	
	state = PlayerState.MOVE
	if not gamestate.is_single_player && is_network_master():
		rset("puppet_state", state)


remotesync func pickup_next_item():
	var collectable:Item = collectable_items_in_reach.pop_back()
	if collectable != null:
		#print_debug("Collectible " + collectable.name + " Owner " + collectable.owner.name)
		collectable.get_parent().remove_child(collectable)
		inventory.add(collectable)
		stashStuff.add_child(collectable)
		collectable.set_owner(self)
		#if collectable.owner != null:
		#	print_debug("Owner is now " + collectable.owner.name)


#func _build_animated_sprite(character_race:String, character_gender:String, character_model:String):
#	var animatedSprite:AnimatedSprite = null
#	var animation_names = ["Idle-E", "Pickup-NW"]
#	for animation in animation_names:
#		animatedSprite.frames.add_animation(animation)
#		var texturepath = "res://basePath/" + character_race + "/" + character_gender + "/" + character_model + "_" + animation + "_" + direction
#		animatedSprite.frames.add_frame(animation,)


func _on_EngagementArea_area_shape_entered(area_rid, area, area_shape_index, local_shape_index): #Initial Chat
	var owner = area.get_parent()
	if owner != self:
		if owner is Item:
			print("No talkie %s" % [owner.name])
		else:
			if not playerControlled:
				if not hadInitialConversation:
					doPromptChat("Hey there! Wanna Chat?")
					hadInitialConversation = true


func _on_InteractWithArea_input_event(viewport, event, shape_idx): #Clicking on the character to continue/start dialog
	if event.is_action_pressed("ui_select"):
		if gamestate.is_single_player || is_network_master():
			beingInteractedWith()
		else:
			rpc_id(1, "beingInteractedWith")


remote func beingInteractedWith():
	if not playerControlled:
			gamestate.use_dialog_box(["Was there something else you needed?"])
	else:
		if not inConversation:
			doPromptChat("Yes, we're interacting!")
		else:
			inConversation = false


func _on_InteractWithArea_mouse_entered():
	print("Mouse Entered")
