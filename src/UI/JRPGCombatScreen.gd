extends Control

onready var tmp_player_bag = $Players
onready var combat_actor_scene = load("res://src/UI/CombatActor.tscn")

var selected_character

func _ready():
	combatmanager.connect("Selected_Character_Changed",self,"toggle_selected_character")


func add_players(player_list):
	var spawnPoint = 0
	for player in player_list:
		var spawn_pos = get_node("SpawnPoints/" + str(spawnPoint)).position
		var combat_actor:CombatActor = combat_actor_scene.instance()
		combat_actor.load_sprite(player.player_character)
		combat_actor.health_current = player.health_current
		combat_actor.health_max = player.health_max
		combat_actor.position = spawn_pos
		tmp_player_bag.add_child(combat_actor)
		if spawnPoint == 0:
			combatmanager.emit_signal("Selected_Character_Changed",combat_actor)
		spawnPoint += 1


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

#Called by signals
func toggle_selected_character(player):
	if selected_character != null:
		selected_character.toggle_selection()
	selected_character = player
	selected_character.toggle_selection()


