extends Node2D

const STAGE_RESOURCE: PackedScene = preload("res://scenes/stage.tscn")

func _on_opening_screen_start_game() -> void:
	var stage = STAGE_RESOURCE.instantiate()
	for child in self.get_children():
		child.queue_free()
	self.add_child(stage)
