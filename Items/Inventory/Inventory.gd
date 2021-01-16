extends Node
class_name Inventory

var items : Array = []
var max_size = 10

func has_space():
	if items.size() < 10:
		return true
	else:
		return false

func add(item):
	items.append(item)
	print("Inventory - Adding - " + item.name)

func remove(to_remove):
	for item in items:
		if item.item_id == to_remove.item_id:
			items.erase(to_remove)
			print("Inventory - Removing - " + to_remove.name)

func pop():
	if items.size() > 0:
		var item = items[0]
		items.erase(item)
		return item
	else:
		return null
