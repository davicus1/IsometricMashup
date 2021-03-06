extends Object
class_name Inventory

var items:Array
var current_mass:float = 0.0
var current_volume:float = 0.0

func add(new_item:Item):
	current_mass += new_item.mass
	current_volume += new_item.volume
	items.append(new_item)

func remove(index):
	assert (items.size() > index)
	var item:Item = items[index]
	items.remove(index)
	current_mass -= item.mass
	current_volume -= item.volume

#func add_to_stack(new_item:Item):
	

#func remove_from_stack(index:int, count:int, item:Item):
#	item.stack_current -= 1
#	if (item.stack_current < 1):
#		items.remove(index)
