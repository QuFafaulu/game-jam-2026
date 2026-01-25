extends CharacterBody2D

@export var max_speed := 300
@onready var interaction_zone: Area2D = $Area2D
var cookable := false #Needed for all area 2Ds or else

var carried_item: Item

signal im_interacting_with_you #unimplemented 
signal is_interacting
signal drop

func _ready():
	# Set the chef's interaction zone to scan all layers that can be
	# interacted with
	interaction_zone.set_collision_mask_value(Global.UTILITY_LAYER, true)
	interaction_zone.set_collision_mask_value(Global.DROPPED_ITEM_LAYER, true)

func get_top_priority_interaction_zone(zones: Array[Area2D]) -> Area2D:
	var prio_zone: Area2D
	# Start with the 0 index zone
	prio_zone = zones[0]
	# Loop through all the zones,
	# floating the highest collision layer zone to the top
	for zone in zones:
		if zone.collision_layer > prio_zone.collision_layer:
			prio_zone = zone
	return prio_zone

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
	var prio_zone: Area2D
	# When the interact input is received, emit the is_interacting
	# signal, along with the zone being interacted with
	if Input.is_action_just_pressed("interact"):
		
		# Get all zones overlapping with the player interaction box
		zones = interaction_zone.get_overlapping_areas()
		drop_carried_item()
		if not zones.is_empty():
			prio_zone  = get_top_priority_interaction_zone(zones)
			is_interacting.emit(prio_zone)
			

func pick_up_item(item: Item):
	# Shift the item up above the chef
	item.global_position = self.global_position + Vector2(0,-20)
	drop_carried_item()
	carried_item = item

func drop_carried_item():
	if carried_item == null:
		return
	else:
		drop.emit(carried_item)
		carried_item = null
