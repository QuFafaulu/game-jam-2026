class_name Item
extends InteractrableObj

@export var texture: Texture2D

@onready var interaction_shape = $CollisionShape2D

func _ready():
	# By default, disable all interaction
	disable_interaction()
	# Set the Sprite to use the texture set by parent scene
	sprite.texture = texture
	# Set the interaction zone to match the sprite size
	interaction_shape.shape.size = sprite.get_rect().size
	

func enable_interaction():
	set_collision_layer_value(Global.DROPPED_ITEM_LAYER, true)

func disable_interaction():
	# Turn off all collision layers
	set_collision_layer_value(Global.UTILITY_LAYER, false)
	set_collision_layer_value(Global.DROPPED_ITEM_LAYER, false)
	set_collision_layer_value(Global.COMBAT_LAYER, false)
	
func interact(... _args: Array) -> InteractrableObj:
	return self
