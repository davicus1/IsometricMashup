extends Node2D
class_name CombatActor

onready var character_sprite = $Sprite
onready var selected_character = $SelectedCharacter
onready var actor_health_bar:ActorHealthBar = $ActorHealthBar
onready var target_character = $TargetCharacter
var texture


var health_current:int
var health_max:int
var defence_bonus:int = 0

func _ready():
	if texture != null:
		character_sprite.texture = texture
	actor_health_bar.health_updated(health_current,health_max)

func block(new_defence_bonus:int):
	defence_bonus = new_defence_bonus

func stop_block():
	defence_bonus = 0

func heal(healthPoints:int):
	health_current = min(health_max,health_current + healthPoints)
	actor_health_bar.health_updated(health_current,health_max)


func take_damage(damagePoints:int):
	health_current = max(0,health_current - damagePoints)
	actor_health_bar.health_updated(health_current,health_max)


func load_sprite(character_type):
	texture = ImageTexture.new()
	var image = Image.new()
	if (character_type == "Human Male"):
		image.load("res://Assets/Characters/Male_4_Idle0.png")
	else: 
		image.load("res://Assets/Characters/FemaleTroll/Isometric_Corona/Idle/Cor_Idle_Up_L_00007.png")
	texture.create_from_image(image)
	if character_sprite != null:
		character_sprite.texture = texture
	return 


func toggle_selection():
	selected_character.visible = not selected_character.visible


func _on_SelectionArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_select"):
		combatmanager.emit_signal("Selected_Character_Changed",self)


func targeted():
	target_character.visible = true


func untargeted():
	target_character.visible = false


