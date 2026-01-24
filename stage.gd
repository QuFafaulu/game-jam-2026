extends StaticBody2D

@onready var chef = $Chef

func _on_chef_is_interacting(zones):
	if not zones.is_empty():
		zones[0].interact()


func _on_fridge_give_item(item) -> void:
	chef.pick_up_item(item) # Replace with function body.
