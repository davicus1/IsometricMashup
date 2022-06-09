extends Control

onready var tmp_player_bag = $Players
onready var tmp_enemy_bag = $Enemies
onready var combat_actor_scene = load("res://src/UI/CombatActor.tscn")
onready var combat_enemy_scene = load("res://src/NPC/CombatEnemy.tscn")

var selected_character
var selected_NPC

func _ready():
	combatmanager.connect("Selected_Character_Changed",self,"toggle_selected_character")
	combatmanager.connect("Selected_NPC_Changed",self,"toggle_selected_NPC")


func add_players(player_list, enemy_list):
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
	
	spawnPoint = 0
	for enemy in enemy_list:
		var spawn_pos = get_node("EnemySpawnPoints/" + str(spawnPoint)).position
		var combat_enemy:CombatEnemy = combat_enemy_scene.instance()
		combat_enemy.health_current = 25
		combat_enemy.health_max = 25
		combat_enemy.position = spawn_pos
		tmp_enemy_bag.add_child(combat_enemy)
		if spawnPoint == 0:
			combatmanager.emit_signal("Selected_NPC_Changed",combat_enemy)
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
	#TODO Placeholder until we pull the enemy's info
	var enemy_list = [0,1,2,3,4,5,6,7]
	add_players(player_list,enemy_list)

#Called by signals
func toggle_selected_character(player):
	if selected_character != null:
		selected_character.toggle_selection()
	selected_character = player
	selected_character.toggle_selection()

#Called by signals
func toggle_selected_NPC(non_player):
	if selected_NPC != null:
		selected_NPC.toggle_selection()
	selected_NPC = non_player
	selected_NPC.toggle_selection()
