extends Node2D

@export var inventory_size: int = 10

var inventory_items_right: Array[Item]
var inventory_items_left: Array[Item]
var base_position_right: Vector2 = Vector2(15,0)
var base_position_left: Vector2 = Vector2(-10,0)
var offset: Vector2 = Vector2(0,-5)

func give_item_left(item: Item):
	if inventory_items_left.size() < inventory_size:
		item.reparent(self)
		inventory_items_left.push_front(item)
		item.position = base_position_left+inventory_items_left.size()*offset
		
func give_item_right(item: Item):
	if inventory_items_right.size() < inventory_size:
		item.reparent(self)
		inventory_items_right.push_front(item)
		item.position = base_position_right+inventory_items_right.size()*offset

func take_item_left() -> Item:
	var item: Item
	if inventory_items_left.size() > 0:
		item = inventory_items_left.pop_front()
		item.visible = true
		return item
	else:
		return null

func take_item_right() -> Item:
	var item: Item
	if inventory_items_right.size() > 0:
		item = inventory_items_right.pop_front()
		item.visible = true
		return item
	else:
		return null
