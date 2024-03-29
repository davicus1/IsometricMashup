extends Node
class_name Gamestate

# Default game port. Can be any number between 1024 and 49151.
const DEFAULT_PORT = 14242

# Max number of players.
const MAX_PEERS = 4

# Name for my player.
var local_player_info = PlayerInfo.new()
var classes = ["Humanoid", "Trollish"]
var characters = ["Human Male", "Female Troll"]


# Names for remote players in id:PlayerInfo format.
var players = {}
var players_ready = []

var is_single_player = true
var local_player_character:Actor
var _current_level:LevelArchtype setget ,get_current_level

##### REMOVE THIS VAR?
var host:NetworkedMultiplayerENet

# Globals
var dialogBox:DialogBox = null


# Signals to let the in-game UI know what's going on
signal health_updated()
signal player_died()
signal paused_state_changed()

# Signals to let lobby GUI know what's going on.
signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal game_ended()
signal game_error(what)

# Callback from SceneTree.
func _player_connected(id):
	# Registration of a client beings here, tell the connected player that we are here.
	rpc_id(id, "register_player", local_player_info.makeAsDictionary())
	##### TODO Adjust This and fix so we don't need a null check here
	if host != null:
		host.set_peer_timeout(id, 100000, 300000, 600000)
	

# Callback from SceneTree.
func _player_disconnected(id):
	if has_node("/root/World"): # Game is in progress.
		if get_tree().is_network_server():
			emit_signal("game_error", "Player " + players[id].player_name + " disconnected")
			##end_game()
	else: # Game is not in progress.
		# Unregister this player.
		unregister_player(id)


# Callback from SceneTree, only for clients (not server).
func _connected_ok():
	# We just connected to a server
	emit_signal("connection_succeeded")


# Callback from SceneTree, only for clients (not server).
func _server_disconnected():
	emit_signal("game_error", "Server disconnected")
	end_game()


# Callback from SceneTree, only for clients (not server).
func _connected_fail():
	get_tree().set_network_peer(null) # Remove peer
	emit_signal("connection_failed")


# Lobby management functions.

remote func register_player(new_player_info):
	var id = get_tree().get_rpc_sender_id()
	print(id)
	var the_real_player_info = PlayerInfo.new()
	the_real_player_info.translateDictionary(new_player_info)
	players[id] = the_real_player_info
	emit_signal("player_list_changed")


func unregister_player(id):
	players.erase(id)
	emit_signal("player_list_changed")


remote func player_creation(new_player_info):
	var id = get_tree().get_rpc_sender_id()
	var the_real_player_info = PlayerInfo.new()
	the_real_player_info.translateDictionary(new_player_info)
	players[id] = the_real_player_info
	emit_signal("player_list_changed")
	update_clients_player_updated(id, new_player_info)

# TODO Maybe the players list should include the server Or the current network master player for client case)
# So that this and the player creation method can be called by everyone and not special cased for the server. See Lobby._on_FinishCreation_pressed
func update_clients_player_updated(id, new_player_info):
		for p in players:
			if p != id:
				rpc_id(p, "player_updated", id, new_player_info)


remote func player_updated(id, new_player_info):
	var the_real_player_info = PlayerInfo.new()
	the_real_player_info.translateDictionary(new_player_info)
	players[id] = the_real_player_info


remote func pre_start_game(spawn_points):
	# Change scene.
	#var map_to_load = load("res://src/Levels/dungeon.tscn").instance()
	var map_to_load = load("res://src/Levels/HotelCalifornia.tscn").instance()
	#var map_to_load = load("res://src/Levels/OldTown.tscn").instance()
	print(map_to_load.get_level_name())
	#get_tree().change_scene_to(dungeon_scene)
	#get_tree().paused = false
	get_tree().get_root().add_child(map_to_load)
	_current_level = map_to_load

	if is_single_player:
		var old_scene = get_tree().get_root().get_node("SingleplayerPlayerCreation")
		old_scene.hide()
		get_tree().get_root().remove_child(old_scene)
	else:
		get_tree().get_root().get_node("Lobby").hide()

	
	
	var y_sorter: YSort = map_to_load.get_node("YSort/Players")
	for p_id in spawn_points:
		var spawn_pos = map_to_load.get_node("SpawnPoints/" + str(spawn_points[p_id])).position
		var player
		if is_single_player || p_id == get_tree().get_network_unique_id():
			player = makePlayerCharacter(local_player_info)
			local_player_character = player
		else:
			var remote_player_info = players[p_id]
			player = makePlayerCharacter(remote_player_info)
		
		player.set_name(str(p_id)) # Use unique ID as node name.
		player.position=spawn_pos
		
		player.set_network_master(p_id) #set unique id as master.
		
		#var floor_tiles: TileMap = world.get_node("Floor")
		#world.add_child_below_node(floor_tiles,player,true)
		#y_sorter.get_node("Players").add_child(player)
		y_sorter.add_child(player)
		
		#world.add_child_below_node(floor_tiles,player,true)
		player.add_to_group("Players",true)
		#world.get_node("Players").add_child(player)
		#world.get_node("Walls").add_child(player)
	y_sorter.set_sort_enabled(false)
	y_sorter.set_sort_enabled(true)
	# Set up score.
	#world.get_node("Score").add_player(get_tree().get_network_unique_id(), player_name)
	#for pn in players:
	#	world.get_node("Score").add_player(pn, players[pn])
	if not is_single_player:
		if not get_tree().is_network_server():
			# Tell server we are ready to start.
			rpc_id(1, "ready_to_start", get_tree().get_network_unique_id())
	elif players.size() == 0:
		post_start_game()


func makePlayerCharacter(player_info:PlayerInfo) -> Actor:
		var player_scene = load("res://src/Actors/" + player_info.player_class + ".tscn")
		var player = player_scene.instance()
		player.set_character_type(player_info.player_character)
		player.set_player_name(player_info.player_name)
		return player 


remote func post_start_game():
	get_tree().set_pause(false) # Unpause and unleash the game!


remote func ready_to_start(id):
	assert(get_tree().is_network_server())

	if not id in players_ready:
		players_ready.append(id)

	if players_ready.size() == players.size():
		for p in players:
			rpc_id(p, "post_start_game")
		post_start_game()

func pause_game_all(is_paused:bool):
	for p in players:
		rpc_id(p, "network_pause", is_paused)
	network_pause(is_paused)

remote func network_pause(is_paused:bool):
	get_tree().set_pause(is_paused)
	emit_signal("paused_state_changed")

#TODO Hack to get single player to work. Then there is the issue of how to start in progress
func single_player_game():
	is_single_player = true
	#register_player(player_name)
	begin_game()

func host_game(new_player_name):
	is_single_player = false
	local_player_info.player_name = new_player_name
	host = NetworkedMultiplayerENet.new()
	var error = host.create_server(DEFAULT_PORT, MAX_PEERS)
	if error != OK:
		printerr("Error creating server! %s" % error)
	get_tree().set_network_peer(host)


func join_game(ip, new_player_name):
	is_single_player = false
	local_player_info.player_name = new_player_name
	var client = NetworkedMultiplayerENet.new()
	client.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(client)



func get_player_list():
	return players.values()


func get_player_name():
	return local_player_info.player_name


func get_player_class():
	return local_player_info.player_class


func get_player_character():
	return local_player_info.player_character


func begin_game():
	if not is_single_player:
		assert(get_tree().is_network_server())

	# Create a dictionary with peer id and respective spawn points, could be improved by randomizing.
	var spawn_points = {}
	spawn_points[1] = 0 # Server in spawn point 0.
	var spawn_point_idx = 1
	for p in players:
		spawn_points[p] = spawn_point_idx
		spawn_point_idx += 1
	# Call to pre-start game with the spawn points.
	if not is_single_player:
		for p in players:
			rpc_id(p, "pre_start_game", spawn_points)

	pre_start_game(spawn_points)


func end_game():
	if has_node("/root/World"): # Game is in progress.
		# End it
		get_node("/root/World").queue_free()

	emit_signal("game_ended")
	players.clear()


func register_dialog_box(the_dialog_box:DialogBox):
	dialogBox = the_dialog_box


func use_dialog_box(pages_of_dialog:Array):
	if dialogBox != null:
		dialogBox.popup(pages_of_dialog)
	else:
		printerr("No Dialog Box Found.")


func _ready():
	#warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_player_connected")
	#warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	#warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_connected_ok")
	#warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_connected_fail")
	#warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func get_current_level() -> LevelArchtype:
	return _current_level
