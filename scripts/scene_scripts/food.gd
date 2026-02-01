class_name Food
extends Item

var type: Global.Meals
var station: Global.Stations
var is_cooking: bool = false
var cooking_speed: float = 0
var cooked: bool = false
@onready var cook_progress: ProgressBar = $CookProgress

@export var cooking_decay_speed: float = 5

const MY_SCENE: PackedScene = preload("res://scenes/food.tscn")

static func new_food(ingredient: Ingredient, station: Station) -> Food:
	var food: Food = MY_SCENE.instantiate()
	food.type = Global.MEAL_TYPES[Vector2(ingredient.type,station.type)]
	food.station = station.type
	return food

func _ready():
	super._ready()
	cook_progress.set_value_no_signal(0)
	cook_progress.visible = false
	sprite.texture = load(Global.MEAL_SPRITES[type]["cooking"])

func start_cooking(station_speed: float):
	is_cooking = true
	cooking_speed = station_speed
	cook_progress.visible = true
	

func stop_cooking():
	is_cooking = false

func _process(delta):
	if is_cooking:
		var new_cook_value = cook_progress.value + delta*cooking_speed
		cook_progress.set_value_no_signal(new_cook_value)
	elif not cooked:
		var new_cook_value = cook_progress.value - delta*cooking_decay_speed
		cook_progress.set_value_no_signal(new_cook_value)

	if cook_progress.value >= 100:
		cook_progress.visible = false
		is_cooking = false
		cooked = true
		sprite.texture = load(Global.MEAL_SPRITES[type]["done"])
		sprite.modulate = Color(1,1,1,1)
