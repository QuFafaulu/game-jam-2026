extends Node2D

@onready var chef = $Chef
@onready var dropped_items = $DroppedItems
@onready var order_manager = $OrderManager
@onready var delivery_window = $DeliveryWindow
@onready var rat_spawn = $RatSpawn
@onready var rat_exit = $RatExit

@export var num_starting_rats: int = 2

const SUS_INGREDIENT_SCENE: PackedScene = preload("res://scenes/sus_ingredient.tscn")
const RAT_SCENE: PackedScene = preload("res://scenes/rat.tscn")

func _ready():
	for i in range(num_starting_rats):
		spawn_rat(0)

# When the chef drops an item, reparent that item to self (the stage)
# and enable its interaction so the chef or others can pick it up again
func _on_chef_drop(item: Item) -> void:
	# Claim the dropped item, and put it under the dropped_items node
	item.reparent(dropped_items)
	# Allow the item to be interacted with
	item.enable_interaction()
	# Set the item's position back to it's position before reparenting
	# (this should leave the item unmoved)
	item.position = chef.position

func _on_delivery_window_deliver_item(item: Food) -> void:
	order_manager.deliver_item(item)

func _on_order_manager_return_item(item: Item) -> void:
	# Claim the dropped item, and put it under the dropped_items node
	item.reparent(dropped_items)
	# Allow the item to be interacted with
	item.enable_interaction()
	# Set the item's position to just under the delivery window
	item.position = delivery_window.position + Vector2(0, 50)

func _on_rat_die(rat: Rat) -> void:
	var dead_rat: SusIngredient = SUS_INGREDIENT_SCENE.instantiate()
	dropped_items.add_child(dead_rat)
	dead_rat.scale = Vector2(4.0,4.0)
	dead_rat.position = rat.position
	dead_rat.type = Global.Ingredients.RAT
	dead_rat.sprite.texture = load(Global.INGREDIENT_SPRITES[dead_rat.type])
	dead_rat.set_interact_area()
	dead_rat.start_rotting()
	dead_rat.enable_interaction()
	rat.queue_free()

func spawn_rat(wait_time: int):
	var rat: Rat = RAT_SCENE.instantiate()
	print("rat spawned")
	self.add_child(rat)
	rat.scale = Vector2(4.0,4.0)
	rat.position = rat_spawn.position
	rat.die.connect(_on_rat_die)
	if wait_time == 0:
		rat.leave_timer.wait_time = randi_range(15,30);
	else:
		rat.leave_timer.wait_time = wait_time
	rat.leave_timer.start()
	rat.exit_node = rat_exit
