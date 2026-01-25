class_name Item
extends InteractableObject

@export var texture: Texture2D

@onready var sprite = $Sprite
@onready var interaction_zone = $Interaction_zone
@onready var interaction_shape = $Interaction_zone/CollisionShape2D

func _ready():
	# By default, disable all interaction
	disable_interaction()
	# Set the Sprite to use the texture set by parent scene
	sprite.texture = texture
	# Set the interaction zone to match the sprite size
	interaction_shape.shape.size = sprite.get_rect().size
	
func interact(... _args: Array) -> InteractableObject:
	return self

func enable_interaction():
	interaction_zone.set_collision_layer_value(Global.DROPPED_ITEM_LAYER, true)

func disable_interaction():
	# Turn off all collision layers
	interaction_zone.set_collision_layer_value(Global.UTILITY_LAYER, false)
	interaction_zone.set_collision_layer_value(Global.DROPPED_ITEM_LAYER, false)
	interaction_zone.set_collision_layer_value(Global.COMBAT_LAYER, false)
