extends InteractableObject

@onready var sprite := $Sprite
@onready var fridge_interact := $FridgeInteract
@onready var inventory := $Inventory

func interact():
	var contents: Array[Node]
	sprite.frame = 1
	contents = inventory.get_children()
	if not contents.is_empty():
		inventory.remove_child(contents[0])
		return [contents[0]]
	else:
		return []

func _on_fridge_interact_body_exited(body: Node2D) -> void:
	# If all interactive entities have left the interaction zone, close the fridge
	if fridge_interact.get_overlapping_areas().is_empty():
		sprite.frame = 0
