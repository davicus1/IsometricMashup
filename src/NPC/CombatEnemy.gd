extends Node2D
class_name CombatEnemy

onready var character_sprite = $Sprite
onready var selected_character = $SelectedCharacter
onready var actor_health_bar:ActorHealthBar = $ActorHealthBar
var texture


var health_current:int
var health_max:int

func _ready():
	actor_health_bar.health_updated(health_current,health_max)


func heal(healthPoints:int):
	health_current = min(health_max,health_current + healthPoints)
	actor_health_bar.health_updated(health_current,health_max)


func take_damage(damagePoints:int):
	health_current = max(0,health_current - damagePoints)
	actor_health_bar.health_updated(health_current,health_max)
	if health_current <= 0:
		self.queue_free()


func load_sprite(character_type):
	pass 


func toggle_selection():
	selected_character.visible = not selected_character.visible


func _on_SelectionArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_select"):
		combatmanager.emit_signal("Selected_NPC_Changed",self)


