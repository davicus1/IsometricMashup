extends Node

#TODO Customize this with an external source or playlist from config
var music_folder:= "res://Assets/music/"
var playlist:= ["PreludeInC-BWV846.ogg"]

export var song_index = 0

onready var _master_bus := AudioServer.get_bus_index("Master")
onready var _music_bus := AudioServer.get_bus_index("BGM")
onready var _sfx_bus := AudioServer.get_bus_index("SFX")

#signal play_music(play)

func _ready():
	AudioServer.set_bus_volume_db(_music_bus, linear2db(GameConfig.volume_music))
	_play_something_if_able()
	

func _next_song():
	if song_index >=  playlist.size():
		song_index = 0
	return music_folder + playlist[song_index]
	
func _play_something_if_able():
	if GameConfig.play_music:
		var stream :AudioStreamOGGVorbis = load(_next_song())
		stream.loop = false
		
		$BackgroundMusic.stream = stream
		$BackgroundMusic.volume_db = linear2db(1.0)
		$BackgroundMusic.play()
		

func _on_BackgroundMusic_finished():
	if GameConfig.play_music:
		song_index +=1
		_play_something_if_able()

func _on_play_music_event(play:bool):
	if play:
		if $BackgroundMusic.stream:
			$BackgroundMusic.play()
			
		else:
			_play_something_if_able()
	else:
		$BackgroundMusic.stop()
