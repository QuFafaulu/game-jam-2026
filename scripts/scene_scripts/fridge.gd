class_name Fridge
extends Node2D

@onready var inventory: Node = $Inventory
@onready var sprite: AnimatedSprite2D = $Sprite

const INGREDIENT_SCENE: PackedScene = preload("res://scenes/ingredient.tscn")

func spawn_beef():
	var beef1: Ingredient = INGREDIENT_SCENE.instantiate()
	add_child(beef1)
	beef1.type = Global.Ingredients.BEEF
	beef1.sprite.texture = load(Global.INGREDIENT_SPRITES[beef1.type])
	beef1.set_interact_area()
	inventory.give_item_left(beef1)
