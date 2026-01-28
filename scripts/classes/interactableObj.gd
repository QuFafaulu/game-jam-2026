class_name InteractrableObj
extends Area2D

@onready var sprite := $Sprite

func interact(_offered_item: Item) -> Item:
	return null

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass # Replace with function body.
