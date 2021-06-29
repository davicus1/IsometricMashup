extends Control
class_name ActorStatusOverlay

onready var health: Label = get_node("Health")
var the_actor

func _ready():
	gamestate.connect("health_updated", self, "update_interface")


func update_interface():
	health.text = "Health %s / %s" % [the_actor.health_current, the_actor.health_max]


func _actor_to_watch(my_actor):
	the_actor = my_actor
	update_interface()
