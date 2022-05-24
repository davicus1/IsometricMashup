extends Control
class_name ActorStatusOverlay

onready var health: Label = get_node("Health")
var the_actor

func _ready():
	pass


func update_interface():
	if the_actor != null:
		health.text = "Health %s / %s" % [the_actor.health_current, the_actor.health_max]


func _actor_to_watch(my_actor):
	the_actor = my_actor
	update_interface()


func _on_Actor_health_updated():
	update_interface() 
