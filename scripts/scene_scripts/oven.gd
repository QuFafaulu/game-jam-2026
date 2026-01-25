extends Station


func _on_area_entered(item: Area2D) -> void:
	print("I see")
	print(item.name)
	if item.cookable:
		print("i cook " + item.name)
		take_item(item)
