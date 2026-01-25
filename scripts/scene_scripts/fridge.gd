extends Station


func interact(... _args: Array) -> Item:
	var contents: Array[Node]
	# Open the fridge
	sprite.frame = 1
	contents = inventory.get_children()
	if not contents.is_empty():
		return contents[0]
	else:
		return null

func _on_fridge_interact_body_exited(_body) -> void:
	print("body exited")
	# If all interactive entities have left the interaction zone, close the fridge
	if get_overlapping_areas().is_empty():
		print("fridge closed")
		# Close the fridge
		sprite.frame = 0
