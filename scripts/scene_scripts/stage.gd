extends Node2D

@onready var chef = $Chef
@onready var dropped_items = $DroppedItems
@onready var rat = $DroppedItems/Rat

func _ready():
	rat.enable_interaction()
	rat.start_rotting()

# When the chef drops an item, reparent that item to self (the stage)
# and enable its interaction so the chef or others can pick it up again
func _on_chef_drop(item: Item) -> void:
	# Claim the dropped item, and put it under the dropped_items node
	item.reparent(dropped_items)
	# Allow the item to be interacted with
	item.enable_interaction()
	# Set the item's position back to it's position before reparenting
	# (this should leave the item unmoved)
	item.position = chef.position
