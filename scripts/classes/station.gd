class_name Station
extends InteractrableObj

var is_cooking: bool = false #records sation state
var cook_progress: float = 0.0 #percent value
var meal_ready: bool = false

@export var type: Global.Stations
@export var cook_speed := 10

@onready var inventory := $Inventory # Holds collected item (multiple items for fridge)

func interact(offered_item: Item) -> Item:
	var offering_item: Food
	offering_item = inventory.get_child(0) # can be null
	if offered_item is Ingredient:
		take_ingredient(offered_item)
	elif offered_item is Food and not offered_item.cooked:
		take_uncooked_food(offered_item)
	return offering_item

func take_ingredient(item: Ingredient): #Collects cookable item
	var cooking_food: Food
	cooking_food = Food.new_food(item, self) # Create a food instance based on station and item
	inventory.add_child(cooking_food) # Add the cooking food to the inventory
	cooking_food.global_position = self.global_position
	cooking_food.start_cooking(cook_speed)
	item.queue_free() # Destroy the ingredient

func take_uncooked_food(food: Food):
	food.reparent(inventory) # Add the cooking food to the inventory
	food.global_position = self.global_position
	food.start_cooking(cook_speed)
