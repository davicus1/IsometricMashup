extends Node
class_name PlayerInfo

var player_name:String = "The Warrior"
var player_class:String = "Humanoid"
var player_character:String = "Female Troll"


func makeAsDictionary():
	return {
		"player_name": player_name,
		"player_character": player_character,
		"player_class": player_class
		}


func translateDictionary(theDictionary):
	player_name = theDictionary["player_name"]
	player_character = theDictionary["player_character"]
	player_class = theDictionary["player_class"]
