extends InteractrableObj

@onready var inventory = $"../Inventory" 

func interact(offered_item: Item) -> Item:
	var offering_item: Item

	if inventory.inventory_items_left.size() <= inventory.inventory_size:
		offering_item = inventory.take_item_left()
		if offering_item is SusIngredient:
			offering_item.start_rotting()
		if offered_item is SusIngredient:
			offered_item.stop_rotting()
		if not offered_item == null:
			inventory.give_item_left(offered_item)
		return offering_item
	else:
		return null
