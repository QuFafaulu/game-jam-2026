extends Node

# Interaction priority: highest number is top priority, 0 is lowest
const PHYSICS_LAYER = 0 # Used by physics bodies, not used for overlaps or interactions
const STATION_INTERACTION_LAYER = 1 # Highest priority, used by interactable stage "stations"
const DROPPED_ITEM_INTERACTION_LAYER = 2 # Used by dropped items
const COMBAT_INTERACTION_LAYER = 3 # Used by combat entities (i.e. rats)
const RAT_LAYER = 4

enum Ingredients {BEEF, RAT}
enum Stations {GRILL, FRIER}
enum Meals {BURGER, CORN_DOG, RAT_BURGER, RAT_DOG}

# Using Vector2 as a two-value tuple equivalent
const MEAL_TYPES: Dictionary = {
	Vector2(Ingredients.BEEF, Stations.GRILL): Meals.BURGER,
	Vector2(Ingredients.BEEF, Stations.FRIER): Meals.CORN_DOG,
	Vector2(Ingredients.RAT,  Stations.GRILL): Meals.RAT_BURGER,
	Vector2(Ingredients.RAT,  Stations.FRIER): Meals.RAT_DOG
}

const INGREDIENT_SPRITES: Dictionary = {
	Ingredients.BEEF: "res://Assets/Raw beef.png",
	Ingredients.RAT:  "res://Assets/Dead rat3.png"
}

const MEAL_SPRITES: Dictionary = {
	Meals.BURGER: {
		"cooking": "res://Assets/Cookingburgermeat.png",
		"done":	   "res://Assets/Borgir.png"
	},
	Meals.CORN_DOG: {
		"cooking": "res://Assets/Corn_dogcooking.png",
		"done":	   "res://Assets/Corn dog(1).png"
	},
	Meals.RAT_BURGER: {
		"cooking": "res://Assets/Cookingratmeat.png",
		"done":	   "res://Assets/Rat Borgir.png"
	},
	Meals.RAT_DOG: {
		"cooking": "res://Assets/Rat_dogcooking.png",
		"done":	   "res://Assets/Rat dog.png"
	}
}

# Level/Order Trackers
var current_level = 1
