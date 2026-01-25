class_name Item
extends InteractrableObj

@export var texture: Texture2D
@export var collision_shape_scale: float = 0.9

@onready var interact_area = $InteractArea
@onready var collision_body = $CollisionBody
@onready var collision_body_shape = $CollisionBody/CollisionBodyShape

func _ready():
	# By default, disable all interaction
	disable_interaction()
	# Set the Sprite to use the texture set by parent scene
	sprite.texture = texture
	# Set the interaction zone to match the sprite size
	interact_area.shape.size = sprite.get_rect().size
	# Set the collision body shape to be a scaled-down version of sprite size
	collision_body_shape.shape.size = sprite.get_rect().size*Vector2(collision_shape_scale, collision_shape_scale)

func enable_interaction():
	set_collision_layer_value(Global.DROPPED_ITEM_INTERACTION_LAYER, true)

func disable_interaction():
	# Turn off all collision layers
	set_collision_layer_value(Global.STATION_INTERACTION_LAYER, false)
	set_collision_layer_value(Global.DROPPED_ITEM_INTERACTION_LAYER, false)
	set_collision_layer_value(Global.COMBAT_INTERACTION_LAYER, false)

func enable_collision():
	collision_body.set_collision_layer_value(Global.PHYSICS_LAYER, true)

func disable_collision():
	collision_body.set_collision_layer_value(Global.PHYSICS_LAYER, false)

func interact(_offered_item: Item) -> Item:
	return self
