class_name InteractableZone
extends Area2D

@export var linked_object: InteractableObject

func interact(...args: Array) -> InteractableObject:
	return linked_object.interact(args)
