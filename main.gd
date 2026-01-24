extends Node

@onready var stage = $stage

func _on_chef_is_interacting() -> void:
	stage.interaction()
