class_name Item
extends InteractrableObj

@export var texture: Texture2D

@onready var interact_area = $InteractArea

func _ready():
	super._ready()
	# By default, disable all interaction
	disable_interaction()
	# Set the Sprite to use the texture set by parent scene
	sprite.texture = texture
	
func set_interact_area():
	# Set the interaction zone to match the sprite size
	interact_area.shape.size = sprite.get_rect().size

func enable_interaction():
	set_collision_layer_value(Global.DROPPED_ITEM_INTERACTION_LAYER, true)

func disable_interaction():
	# Turn off all collision layers
	set_collision_layer_value(Global.STATION_INTERACTION_LAYER, false)
	set_collision_layer_value(Global.DROPPED_ITEM_INTERACTION_LAYER, false)
	set_collision_layer_value(Global.COMBAT_INTERACTION_LAYER, false)

func interact(_offered_item: Item) -> Item:
	# Items never take an offered item and always offer themselves to be picked up
	return self
