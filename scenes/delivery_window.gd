class_name DeliveryWindow
extends InteractrableObj

signal deliver_item(item: Food)

func interact(offered_item: Item) -> Item:
	if offered_item is Food:
		if offered_item.cooked == true:
			deliver_item.emit(offered_item)
	return null
