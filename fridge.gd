extends InteractableObject

@onready var sprite := $Sprite
@onready var fridge_interact := $FridgeInteract

@onready var apple := $Apple

signal give_item


func _ready():
	fridge_interact.connect("interacted_with", _on_interaction)

func _on_interaction():
	sprite.frame = 1
	remove_child(apple)
	give_item.emit(apple)

func _on_fridge_interact_body_exited(body: Node2D) -> void:
	# If all interactive entities have left the interaction zone, close the fridge
	if fridge_interact.get_overlapping_areas().is_empty():
		sprite.frame = 0
