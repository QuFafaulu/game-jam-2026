extends Node2D

@onready var inventory_slots: Array[Node2D] = [$InventorySlot0,\
											   $InventorySlot1,\
											   $InventorySlot2,\
											   $InventorySlot3]

@export var inventory_size: int = 4

var inventory_items: Array[Item]

func give_item(item: Item):
	if inventory_items.size() < inventory_size:
		inventory_items.push_front(item)
		refresh_slots()
		
func take_item() -> Item:
	var item: Item
	if inventory_items.size() > 0:
		item = inventory_items.pop_front()
		refresh_slots()
		return item
	else:
		return null

func refresh_slots():
	for i in inventory_items.size():
		inventory_items[i].reparent(inventory_slots[i])
		inventory_items[i].position = inventory_slots[i].position
