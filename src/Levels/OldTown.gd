extends Node2D

var current_phase = 1
onready var phase_1_rubble = $"YSort/RubblePhase1"
onready var phase_2_buildings = $"YSort/BuildingsPhase2"

func _ready():
	pass



func _process(delta):
	if Input.is_action_pressed("Phase2"):
		if current_phase < 2:
			phase_1_rubble.set_deferred("visible", false)
			phase_2_buildings.set_deferred("visible", true)
			current_phase = 2
			
