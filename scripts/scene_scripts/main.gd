extends Node2D

const STAGE_RESOURCE: PackedScene = preload("res://scenes/stage.tscn")
const VICTORY_SCREEN: PackedScene = preload("res://scenes/victory_screen.tscn")
const FAILURE_SCREEN: PackedScene = preload("res://scenes/failure_screen.tscn")

func _on_opening_screen_start_game() -> void:
	var stage = STAGE_RESOURCE.instantiate()
	for child in self.get_children():
		child.queue_free()
	self.add_child(stage)
	stage.victory_screen.connect(_on_stage_victory_screen)
	stage.failure_screen.connect(_on_stage_failure_screen)
	
func _on_stage_victory_screen():
	var ending_screen = VICTORY_SCREEN.instantiate()
	for child in self.get_children():
		child.queue_free()
	self.add_child(ending_screen)
	
func _on_stage_failure_screen():
	var ending_screen = FAILURE_SCREEN.instantiate()
	for child in self.get_children():
		child.queue_free()
	self.add_child(ending_screen)
