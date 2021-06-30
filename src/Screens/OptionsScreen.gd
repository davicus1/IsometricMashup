extends Control

onready var _Master_bus = AudioServer.get_bus_index("Master")
onready var _BGM_bus = AudioServer.get_bus_index("BGM")
onready var _SFX_bus = AudioServer.get_bus_index("SFX")

signal play_music(play)


func _ready():
	$VBoxContainer/HBoxContainer2/BackgroundVolume.value = GameConfig.volume_music
# warning-ignore:return_value_discarded
	connect("play_music",Music,"_on_play_music_event")


func _on_PlayMusicCheckBox_toggled(button_pressed):
	GameConfig.play_music = button_pressed
	emit_signal("play_music",button_pressed)


func _on_Save_pressed():
	GameConfig.saveConfig()
	self.visible = false


func _on_BackButton_pressed():
	self.visible = false
