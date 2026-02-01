extends Node2D

@export var inventory_size: int = 10

var inventory_items: Array[Item]
var base_position: Vector2 = Vector2(0,0)
var offset: Vector2 = Vector2(0,-5)

func give_item(item: Item):
	if inventory_items.size() < inventory_size:
		item.reparent(self)
		inventory_items.push_front(item)
		item.position = base_position+inventory_items.size()*offset

func take_item() -> Item:
	var item: Item
	if inventory_items.size() > 0:
		item = inventory_items.pop_front()
		item.visible = true
		return item
	else:
		return null
