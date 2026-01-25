extends Node2D

@onready var chef = $Chef
@onready var dropped_items = $DroppedItems

func _on_chef_is_interacting(zone):
	var aquired_item: InteractableObject
	# Call interact on the interacted-with zone,
	# if the zone delivers an item it be returned
	aquired_item = zone.interact()
	# If the zone did give an item, reparent it
	# to the chef and disable it's interaction
	# because an item being carried by the chef should never interact
	if not aquired_item == null:
		aquired_item.reparent(chef)
		aquired_item.disable_interaction()
		chef.pick_up_item(aquired_item)

# When the chef drops an item, reparent that item to self (the stage)
# and enable its interaction so the chef or others can pick it up again
func _on_chef_drop(item: Item) -> void:
	item.reparent(self)
	item.enable_interaction()
	# Set the item's position based on the chef's current position,
	# could be changed to drop items on specific spots
	item.position = chef.position + Vector2(0,-20)
