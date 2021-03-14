extends KinematicBody2D
class_name Actor

var health_current:int
var health_max:int
var mass:float
var volume:float
var inventory:Inventory
var capacity:Capacity
var character_name:String

var collectable_items_in_reach:Array = []

func _ready():
	pass
