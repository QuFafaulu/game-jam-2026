class_name Station
extends InteractrableObj

var is_cooking: bool = false #records sation state
var cook_progress: float = 0.0 #percent value
var meal_ready: bool = false

@export var cook_time := 10

@onready var inventory := $Inventory # Holds collected item (multiple items for fridge)
@onready var progress_bar := $ProgressBar

func interact(offered_item: Item) -> Item:
	var offering_item: Item
	if not inventory.get_child(0) == null and not is_cooking:
		#if is_cooking:
		#	interrupt_cooking()
		offering_item = inventory.get_child(0)
	else:
		offering_item = null
	if not offered_item == null and offered_item.cookable and not is_cooking:
		take_item(offered_item)
	return offering_item

func take_item(item: Item): #Collects cookable item
	item.reparent(inventory)
	item.global_position = self.global_position
	item.disable_interaction()
	item.disable_collision()
	start_cooking(item)

func start_cooking(food: Item): #Starts cooking collected item
	food.hide()
	is_cooking = true

func interrupt_cooking():
	var meal = inventory.get_child(0)
	
	meal.show()
	cook_progress = 0
	is_cooking = false

func finish_cooking(): #Present cooked item and notify player
	var meal = inventory.get_child(0) #fetch meal
	
	#prepare meal for player interaction
	meal.sprite.texture = load("res://sprites/Borgir.png")
	meal.show()
	meal.cookable = false
	
	#set station to meal_ready state
	meal_ready = true
	cook_progress = 0
	is_cooking = false

func _process(delta: float) -> void:
	if is_cooking:
		cook_progress += delta
	if cook_progress >= cook_time:
		finish_cooking()
	if not progress_bar == null: # bug? every other process cycle, the progress bar is null
		progress_bar.max_value = cook_time
		progress_bar.set_value_no_signal(cook_progress)
