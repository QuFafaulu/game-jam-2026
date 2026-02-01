class_name Fridge
extends InteractrableObj

@onready var inventory: Node = $Inventory

const INGREDIENT_SCENE: PackedScene = preload("res://scenes/ingredient.tscn")

func spawn_beef():
	var beef1: Ingredient = INGREDIENT_SCENE.instantiate()
	add_child(beef1)
	beef1.type = Global.Ingredients.BEEF
	beef1.sprite.texture = load(Global.INGREDIENT_SPRITES[beef1.type])
	beef1.set_interact_area()
	inventory.give_item(beef1)

func interact(offered_item: Item) -> Item:
	var offering_item: Item
	# Open the fridge
	sprite.frame = 1

	if inventory.inventory_items.size() <= inventory.inventory_size:
		offering_item = inventory.take_item()
		if offering_item is SusIngredient:
			offering_item.start_rotting()
		if offered_item is SusIngredient:
			offered_item.stop_rotting()
		if not offered_item == null:
			inventory.give_item(offered_item)
		return offering_item
	else:
		return null

func _on_fridge_interact_body_exited(_body) -> void:
	print("body exited")
	# If all interactive entities have left the interaction zone, close the fridge
	if get_overlapping_areas().is_empty():
		print("fridge closed")
		# Close the fridge
		sprite.frame = 0
