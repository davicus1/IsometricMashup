extends Node2D
class_name ActorHealthBar

onready var health_bar = $HealthBar

func _ready():
	pass # Replace with function body.

func health_updated(health_current,health_max):
	# receive int value
	health_bar.max_value = health_max
	health_bar.value = health_current
	
	
	# receive combat actor and query health current & max
	# know what its combat actor is, has a var that points to combat actor
	# can ask what is it current health current & max

