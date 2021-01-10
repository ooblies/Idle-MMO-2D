extends Node
class_name Inventory

var items : Array = []

func add(item):
	items.append(item)
	print("Inventory - Adding - " + item.name)

func remove(to_remove):
	for item in items:
		if item.item_id == to_remove.item_id:
			items.erase(to_remove)
			print("Inventory - Removing - " + to_remove.name)
