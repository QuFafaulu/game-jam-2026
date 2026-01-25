class_name Station
extends InteractrableObj

signal request_reparent(station: Station, item: InteractrableObj)
var is_cooking: bool = false #records sation state
var cook_progress: int = 0 #percent value
var meal_ready: bool = false

@onready var inventory := $Inventory #Holds collected item (multiple items for fridge)

func interact(... _args: Array) -> InteractrableObj:
	return null

func take_item(item: InteractrableObj): #Collects cookable item dropped on it
	if not is_cooking:
		request_reparent.emit(self, item)
		item.global_position = self.global_position
		item.disable_interaction()
		start_cooking(item)
		
func start_cooking(food: Item): #Starts cooking collected item
	food.hide()
	is_cooking = true

func finish_cooking(): #Present cooked item and notify player
	
	var meal = $Inventory.get_child(0) #fetch meal
	
	#prepare meal for player interaction
	meal.texture = load("res://sprites/Borgir.png") #NOT WORKING
	meal.show()
	meal.cookable = false
	meal.enable_interaction()
	
	print("Meal ready!") #replace with singal to Main
	
	#set station to meal_ready state
	meal_ready = true
	cook_progress = 0
	is_cooking = false
	
	
func _process(delta: float) -> void:
	if is_cooking:
		cook_progress += 1
	if cook_progress >= 100:
		finish_cooking()
		
		
