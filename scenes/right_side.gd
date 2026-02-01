extends InteractrableObj

@onready var inventory = $"../Inventory" 

func interact(offered_item: Item) -> Item:
	var offering_item: Item

	if offered_item == null:
		if inventory.inventory_items_right.size() <= inventory.inventory_size:
			offering_item = inventory.take_item_right()
			if offering_item is SusIngredient:
				offering_item.start_rotting()
			return offering_item
		else:
			return null
	else:
		if offered_item is SusIngredient:
			offered_item.stop_rotting()
		inventory.give_item_right(offered_item)
		return null
