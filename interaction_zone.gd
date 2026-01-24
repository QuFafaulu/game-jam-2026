class_name InteractionZone
extends Area2D

@export var connected_object: InteractableObject

func interact(... args: Array):
	return connected_object.interact(args)
