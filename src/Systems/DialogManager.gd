extends Node

class_name DialogManager

## Who triggering interaction
##  L what items do we have
##  L Factions we have
##  L Reputation we have
##  L Who is in your party/crew
## Where is the event
##  L Level
##  L Location
## What are we interacting with
## When is the event triggered
## Story Progression
##  L Completed missions
##  L Completed chapters

## Who, Level, Location, What, Story Completed Mission

func get_current_dialog() -> Array:
	var level_name = gamestate.get_current_level().get_level_name()
	var dialog_to_return = "Hello, what do you think of %s?" % [level_name]
	return [dialog_to_return]
