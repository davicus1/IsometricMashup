extends Control

onready var label: Label = get_node("Score")


func _ready():
	label.text = label.text % [PlayerData.score, PlayerData.deaths]
