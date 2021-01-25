extends Node

var config_save_path = "user://dw_game.cfg"
var config_data = ConfigFile.new()

func _ready():
	var load_response = config_data.load(config_save_path)
	loadConfig()
	

#Audio
export var play_music:= true
export var volume_music:= 1.0
#TODO Not Implemented volume_sfx
export var volume_sfx:= 1.0
onready var _master_bus := AudioServer.get_bus_index("Master")
onready var _music_bus := AudioServer.get_bus_index("BGM")
onready var _sfx_bus := AudioServer.get_bus_index("SFX")


#Network
export var network_port:= 14242

#Display
#TODO Not Implemented display_fullscreen
export var display_fullscreen:= false

func saveConfig():
	config_data.set_value("Audio", "PlayMusic", play_music)
	config_data.set_value("Audio", "MusicVolume", volume_music)
	config_data.set_value("Audio", "SFXVolume", volume_sfx)
	config_data.set_value("Network", "Port", network_port)
	config_data.set_value("Display", "Fullscreen", display_fullscreen)
	config_data.save(config_save_path)

#TODO Missing Validation of value ranges
func loadConfig():
	play_music = config_data.get_value("Audio", "PlayMusic", play_music)
	volume_music = config_data.get_value("Audio", "MusicVolume", volume_music)
	volume_sfx = config_data.get_value("Audio", "SFXVolume", volume_sfx)
	network_port = config_data.get_value("Network", "Port", network_port)
	display_fullscreen = config_data.get_value("Display", "Fullscreen", display_fullscreen)


func set_volume_for_bus(bus: int, value:float):
	if _music_bus == bus:
		volume_music = value

