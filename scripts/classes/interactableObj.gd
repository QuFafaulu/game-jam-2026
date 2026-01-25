class_name InteractrableObj
extends Area2D

@export var tint: Color #Property for easy recolours, but couldnt get it to work so unimplemented
						#use built-in Modulate property instead

@export var cookable: bool = false  #flag for stations to decide what they should interact with.
		
@onready var sprite := $Sprite



func interact(... _args: Array) -> InteractrableObj:
	return null





func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass # Replace with function body.
