extends CharacterBody2D

@export var max_speed := 300
@export var inventory_slot_y_offset := -20
@onready var interaction_zone: Area2D = $InteractionArea
@onready var inventory: Node2D = $Inventory
@onready var sprite: AnimatedSprite2D = $Sprite

signal drop #Emitted when the chef drops an inventory item, to be intercepted by the stage

func _ready():
	# Set the chef's interaction zone to scan all layers that can be
	# interacted with
	interaction_zone.set_collision_mask_value(Global.STATION_INTERACTION_LAYER, true)
	interaction_zone.set_collision_mask_value(Global.DROPPED_ITEM_INTERACTION_LAYER, true)
	self.set_collision_layer_value(Global.PHYSICS_LAYER, true)

func _physics_process(_delta): #Handles player movement
	var input_dir: Vector2
	# Use Input's get_vector function, which can convert either analog or digital inputs
	# into a vector scaled to a max amplitude of 1
	input_dir = Input.get_vector("move_left","move_right","move_up","move_down")
	# Since input_dir is scaled to 1, we can get actual velocity by scaling it by max_speed
	velocity = input_dir*max_speed
	# Use the built-in funciton move_and_slide(),
	# this function shifts some velocity in the direction along
	# wall on inpact, which feels intuitive
	move_and_slide()

func _input(_event):
	var zones: Array[Area2D]
	var prio_obj: InteractrableObj
	# When the interact input is received, emit the is_interacting
	# signal, along with the zone being interacted with
	if Input.is_action_just_pressed("interact"):
		# Get all Area2Ds overlapping with the player interaction box
		zones = interaction_zone.get_overlapping_areas()
		if not zones.is_empty():
			prio_obj  = get_top_priority_interactable_obj(zones)
			if not prio_obj == null: # It's possible for none of the zone to be InteractableObj
				var aquired_item = prio_obj.interact(inventory.get_child(0))
				if not aquired_item == null:
					pick_up_item(aquired_item)
				# Exit the _input function now if an interactable object was found,
				# skip the dropped_carried_item below
				return
			else:
				for zone in zones:
					if zone is RatZone:
						zone.kill_rat()
		# If an interaction with an InteractableObj did not occur, 
		# instread drop the carried item
		drop_carried_item()

# Takes an array of Area2Ds (which may or may not include InteractableObj instances)
# and returns the InteractableObj on the highest collision layer (if it exists)
# Otherwise returns null
func get_top_priority_interactable_obj(zones: Array[Area2D]) -> InteractrableObj:
	var prio_zone: InteractrableObj = null
	# Loop through all the zones,
	# floating the highest collision layer zone to the top
	for zone in zones:
		# Find the first InteractableObj within the zones, and set prio zone to that
		if prio_zone == null and zone is InteractrableObj:
			prio_zone = zone
		# If any InteractableObj has a higher collision_layer, replace as prio_zone
		if zone is InteractrableObj and zone.collision_layer > prio_zone.collision_layer:
			prio_zone = zone
	return prio_zone

func pick_up_item(item: Item):
	# Drop the carried item if any
	drop_carried_item()
	# Claim ownership of the item
	item.reparent(inventory)
	item.disable_interaction()
	if item is Food:
		item.stop_cooking()
	# Shift the new item up above the chef
	item.position = Vector2(0, inventory_slot_y_offset)

func drop_carried_item():
	# If the chef is not carrying an item, do nothing
	if inventory.get_child(0) == null:
		return
	# Emit to drop signal so the stage can take control of the item
	else:
		drop.emit(inventory.get_child(0))
