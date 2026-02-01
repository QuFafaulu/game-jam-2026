class_name Trash
extends InteractrableObj

func interact(offered_item: Item) -> Item:
	if not offered_item == null:
		offered_item.queue_free()
	return null
