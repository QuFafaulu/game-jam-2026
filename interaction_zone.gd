class_name InteractionZone
extends Area2D

@export var connected_object: InteractableObject
signal interacted_with

func interact():
	return connected_object.interact()
