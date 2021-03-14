extends Node2D
class_name Item

var _constructed:bool

var scene_for_item
var icon:Texture
var collectable:bool
var health_current:int
var health_max:int
var mass:float
var volume:float
var inventory
var capacity:Capacity
var item_name:String
var item_description:String
var equipment:Equipment
var stackable:bool
var stack_max:int
var stack_current:int


func _ready():
	pass
