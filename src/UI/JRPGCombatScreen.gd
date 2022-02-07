extends Control

onready var tmp_player_bag = $Players

func add_players(player_list):
	var spawnPoint = 0
	for player in player_list:
		var spawn_pos = get_node("SpawnPoints/" + str(spawnPoint)).position
		var character_sprite = load_sprite(player.player_character)
		character_sprite.position = spawn_pos
		tmp_player_bag.add_child(character_sprite)
		spawnPoint += 1
		

func load_sprite(character_type) -> Sprite:
	var character_sprite = Sprite.new()
	var texture = ImageTexture.new()
	var image = Image.new()
	if (character_type == "Human Male"):
		image.load("res://Assets/Characters/Male/Male_4_Idle0.png")
	else: 
		image.load("res://Assets/Characters/FemaleTroll/Isometric_Corona/Idle/Cor_Idle_Up_L_00007.png")
	texture.create_from_image(image)
	character_sprite.texture = texture
	return character_sprite


func _on_LoadPlayers_pressed():
	
	var player1info:PlayerInfo = PlayerInfo.new()
	var player2info:PlayerInfo = PlayerInfo.new()
	player2info.player_name = "The Bard"
	player2info.player_character = "Human Male"
#	var player1 = makePlayerCharacter(player1info)
#	var player2 = makePlayerCharacter(player2info)
#	tmp_player_bag.add_child(player1)
#	tmp_player_bag.add_child(player2)
#	player1.add_to_group("Players")
#	player2.add_to_group("Players")
#	player1.myCamera.clear_current()
#	player2.myCamera.clear_current()
	
#	var player_list = get_tree().get_nodes_in_group("Players")
	var player_list = [player1info,player2info]
	add_players(player_list)


func makePlayerCharacter(player_info:PlayerInfo) -> Actor:
		var player_scene = load("res://src/Actors/" + player_info.player_class + ".tscn")
		var player = player_scene.instance()
		player.set_character_type(player_info.player_character)
		player.set_player_name(player_info.player_name)
		return player 
