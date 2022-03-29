extends Control

onready var tmp_player_bag = $Players
onready var combat_actor_scene = load("res://src/UI/CombatActor.tscn")


var selectedPlayer


func add_players(player_list):
	var spawnPoint = 0
	for player in player_list:
		var spawn_pos = get_node("SpawnPoints/" + str(spawnPoint)).position
		var combat_actor:CombatActor = combat_actor_scene.instance()
		combat_actor.load_sprite(player.player_character)
		combat_actor.position = spawn_pos
		tmp_player_bag.add_child(combat_actor)
		if spawnPoint == 0:
			SelectPlayer(combat_actor)
		spawnPoint += 1
		combat_actor.connect("combatActorSelected",self,"SelectPlayer")




func _on_LoadPlayers_pressed():
	
	var player1info:PlayerInfo = PlayerInfo.new()
	var player2info:PlayerInfo = PlayerInfo.new()
	player2info.player_name = "The Bard"
	player2info.player_character = "Human Male"
	var player3info:PlayerInfo = PlayerInfo.new()
	player3info.player_name = "The Bard"
	player3info.player_character = "Human Male"
	var player4info:PlayerInfo = PlayerInfo.new()
	player4info.player_name = "The Bard"
	player4info.player_character = "Human Male"
	var player5info:PlayerInfo = PlayerInfo.new()
	player5info.player_name = "The Bard"
	player5info.player_character = "Human Male"
	var player6info:PlayerInfo = PlayerInfo.new()
	player6info.player_name = "The Bard"
	player6info.player_character = "Human Male"
	var player7info:PlayerInfo = PlayerInfo.new()
	player7info.player_name = "The Bard"
	player7info.player_character = "Human Male"
	var player8info:PlayerInfo = PlayerInfo.new()
	player8info.player_name = "The Bard"
	player8info.player_character = "Human Male"
#	var player1 = makePlayerCharacter(player1info)
#	var player2 = makePlayerCharacter(player2info)
#	tmp_player_bag.add_child(player1)
#	tmp_player_bag.add_child(player2)
#	player1.add_to_group("Players")
#	player2.add_to_group("Players")
#	player1.myCamera.clear_current()
#	player2.myCamera.clear_current()
	
#	var player_list = get_tree().get_nodes_in_group("Players")
	var player_list = [player1info,player2info,player3info,player4info,player5info,player6info,player7info,player8info]
	add_players(player_list)


func SelectPlayer(player):
	if selectedPlayer != null:
		selectedPlayer.toggleSelection()
	selectedPlayer = player
	selectedPlayer.toggleSelection()


func makePlayerCharacter(player_info:PlayerInfo) -> Actor:
		var player_scene = load("res://src/Actors/" + player_info.player_class + ".tscn")
		var player = player_scene.instance()
		player.set_character_type(player_info.player_character)
		player.set_player_name(player_info.player_name)
		return player 
