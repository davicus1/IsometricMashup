extends Node2D
class_name CombatActor

onready var character_sprite = $Sprite
var texture

func _ready():
	if texture != null:
		character_sprite.texture = texture



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
