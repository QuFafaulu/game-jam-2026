class_name InteractionZone
extends Area2D

signal interacted_with

func interact():
	interacted_with.emit()
