extends Node

#NOTE TO access array of orders, use G_Level.Levels[Global.current_level]

var _lvl_filepaths : PackedStringArray 
var _lvl_dir = "res://Data/Levels/"
var Levels: Array	# Global access variable -> Array of Arrays. 
					# each element is a Game Level 
					# each Game Level is an array of orders(type:Dict) 
					#region : NEW Game Level JSON format - EVENTS
"""
					{
						"event type": String ("order", "restock", "rat")
						"index": int (1,2,3,...)  (seperate tallies for each event type)
						"start time": int (seconds from level start)
						"amount": int (number of raw meat restocked in fridge, or rats spawned)
						"order items": [Strings] ("burger", "rat")
						"order text": String ("I want a burger!")
						"order patience": int (seconds)  
						"order score": int (points for successful order)
					}
"""
					#endregion --------------------


#NOTE Namespace for order look up
const ORDER_NUM = "order number"
const ORDER_ITEMS = "items"
const ORDER_TEXT = "text"
const ORDER_PATIENCE = "patience"
const ORDER_START_TIME = "start time"
const ORDER_MAX_TIP = "max tip"
const ORDER_ITEM_DELIVERED = "items_delivered"


# Reutrns string array of all level filepaths
func get_filepaths (dir) -> PackedStringArray:  
	var filenames: PackedStringArray = DirAccess.get_files_at(dir) # store array of all *filenames* of JSON files in /Levels/
	var filepaths: PackedStringArray 	#declare array to hold all *filepaths* for said files
	for filename in filenames: 			# populate filepaths array
		filepaths.append(_lvl_dir + filename)
	return filepaths


#Iternates over all given file paths and returns the data as an array of arrays of dicts
func get_data_from_paths(filepaths) -> Array:
	var all_lvls: Array		# Container for game level data: Array of Arrays
	all_lvls.append([])		# Bump array with blank array to align interator with Levels enumeration
	
	# Iternate thru all level files and populate above container with level data
	for file in filepaths:		
		var data = FileAccess.open(file, FileAccess.READ) 	# Create FileAccess object containing level data
		if data:
			var parse_result = JSON.parse_string(data.get_as_text()) # Parse JSON-format string into Dict
			#NOTE Due to our JSON formatting, parse_results is a one element Dict of the form:
			#			`parse-results["Orders"] = [{order 1],...,{Order n}]`
			# Let's unpack that to access the array of orders:
			var result_array = parse_result["Orders"]
			
			all_lvls.append(result_array) #NOTE Populates all_lvls such that Levels[i] => array of orders of Game Level i
		
	return all_lvls #Return container full of level data


# DEBUGGING function for iterating over PackedDataContainers, whose contents cannot be printed to console wholesale
func iter_print_recursive(iterable):
		for item in iterable:
			if typeof(item) == TYPE_OBJECT:
				iter_print_recursive(item)
			else:
				#assume item is key in dict, and iterable is dict
				if item == "items":
					var list_of: Array
					for ii in iterable[item]:
						list_of.append(ii)
					print(item + ": " + str(list_of))
				else:
					print(item + ": " + str(iterable[item]))


func _ready() -> void:
	_lvl_filepaths = get_filepaths(_lvl_dir) 		# Populate with filepaths from /Data/Levels/
	Levels = get_data_from_paths(_lvl_filepaths)	#NOTE Populates array such that Levels[i] => array of orders of Game Level i
													#NOTE Levels[0] = [], order data starts at Levels[1] 


#region Unused code------

#Dummy case for testing single dictionary storage of levels
#var levels: Dictionary
#var level_filepath = "res://Data/orders.json"
#func get_all_levels() -> Dictionary:
	#var file = FileAccess.open(level_filepath, FileAccess.READ)
	#if file:
		#var parse_results = JSON.parse_string(file.get_as_text())
		#levels = parse_results["dummy key"]
	#return levels


# These two lines are leftover from when I tried saving level data using PackedDataContainer's. What a pain
# var Levels = PackedDataContainer.new() #NOTE Tried using PackedDataContainer but it is obnoxious for debugging and inspecting
#Levels.pack(get_data_from_paths()) # The pack() function is for populating PackedDataContainer's. Not using that data sturcture currently
#endregion ----------------------------------------------------------------

#DEPRECATED
					#region : OLD  JSON format
"""
					{
						"order_number": int,
						"items": [Strings],
						"text": String,
						"patience": int,  
						"start time": int,
						"max tip": int
						"items_delivered": int
					}
"""
					#endregion --------------------
