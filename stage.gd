extends StaticBody2D

@onready var chef = $Chef

func _on_chef_is_interacting(zones):
	var aquired_items
	if not zones.is_empty():
		aquired_items = zones[0].interact()
		if not aquired_items.is_empty():
			chef.pick_up_item(aquired_items[0])


func _on_chef_drop(item: Sprite2D, position: Vector2) -> void:
	add_child(item)
	item.global_position = position
	print(item)
