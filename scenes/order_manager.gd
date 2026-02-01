extends Control

#NOTE SEND SIGNALS TO func deliver_items(item_type: String,is_rat: bool): #item_type means "burger" or "corn dog" is_rat is bool

signal order_success # passes the order object -> Array[Dict]
signal order_fail # passes the order object -> Array[Dict]
signal return_item(item: Item)
var orders: Array #Will always contains full order list for the level. 
var open_orders: Array = []
var active_order_count = 0
var current_order_num: int = 0 #In practice, indexes from 1 to match meal order indexing
@onready var level_timer: Timer = %LevelTimer
@onready var order_panel: Panel = %OrderPanel
var order_slips: Array
var order_slip_image = preload("uid://boldly13v1o0x")
var cross_out_image = preload("uid://bqb83js1n1kda")

const ticket_height = 50

var start_timers: Array
var patience_timers: Array
var order_labels: Array

func start_next_order(_id): # _id counts as such: "Timer", "Timer2", etc.
	current_order_num += 1
	active_order_count += 1
	var this_order = orders[current_order_num-1]
	var new_pateince_timer = Timer.new()
	self.add_child(new_pateince_timer)
	new_pateince_timer.name = "PatienceTimer" + str(current_order_num)
	new_pateince_timer.wait_time = this_order[G_Level.ORDER_PATIENCE]
	new_pateince_timer.timeout.connect(_on_patience_timer_timeout.bind(new_pateince_timer.name,current_order_num))
	new_pateince_timer.one_shot = true
	new_pateince_timer.start()
	patience_timers.append(new_pateince_timer)
	self.display_order(this_order)
	open_orders.append(this_order)

	
func create_order_timeline(orders) -> Array:
	var timer_array: Array
	for order in orders:
		var start_time
		start_time = order[G_Level.ORDER_START_TIME]
		var new_timer = Timer.new()
		new_timer.wait_time = start_time
		timer_array.append(new_timer)
	return timer_array

func start_order_timers():
	for timer in start_timers:
		self.add_child(timer, true)
		timer.timeout.connect(_on_start_timer_timeout.bind(timer.name))
		timer.one_shot = true
		timer.start()
	pass

func _on_start_timer_timeout(id):
	start_next_order(id)

func on_order_success(order):
	var order_number = order[G_Level.ORDER_NUM]
	active_order_count -= 1
	open_orders[order_number-1] = 0 # When checking open orders, first check if typeof(open_orders[i]) == TYPE_INT: skip
	order_slips[order_number-1].set_texture(cross_out_image)
	var tween = get_tree().create_tween()
	tween.tween_property(order_slips[order_number-1], "modulate",Color(0.145, 0.592, 0.0, 1.0), 0.5)
	tween.tween_property(order_slips[order_number-1], "scale", Vector2(), 2)
	for i in range(order_number,order_slips.size()):
		if typeof(order_slips[i]) != TYPE_INT:
			print("poping #" + str(i))
			order_slips[i].set_position(order_slips[i].position + Vector2(0,-85)) 
			
			
func _on_patience_timer_timeout(timer_name, order_number):
	active_order_count -= 1
	open_orders[order_number-1] = 0 # When checking open orders, first check if typeof(open_orders[i]) == TYPE_INT: skip
	order_slips[order_number-1].set_texture(cross_out_image)
	var tween = get_tree().create_tween()
	tween.tween_property(order_slips[order_number-1], "modulate",Color(0.553, 0.102, 0.043, 1.0), 0.5)
	tween.tween_property(order_slips[order_number-1], "scale", Vector2(), 2)
	for i in range(order_number,order_slips.size()):
		if typeof(order_slips[i]) != TYPE_INT:
			print("poping #" + str(i))
			order_slips[i].set_position(order_slips[i].position + Vector2(0,-85)) 
	order_fail.emit(orders[order_number-1])

func display_order(order):
	#region Create and display order slip
	var new_order_slip = TextureRect.new()
	new_order_slip.set_size(Vector2(0,85)) #only y-value of vector2 matters here. object is scales proportionally
	new_order_slip.set_stretch_mode(5)
	new_order_slip.set_expand_mode(3)
	new_order_slip.set_texture(order_slip_image)
	order_panel.add_child(new_order_slip)
	new_order_slip.set_position(new_order_slip.position + Vector2(0,(85*(active_order_count-1))))
	#endregion --------------------------
	var order_text = generate_order_text(order)
	#region Order slip text Object creation / formatting
	var new_order = RichTextLabel.new()
	new_order.size = Vector2(210+25,50+14)
	#new_order.scroll_active = false #NOTE scroll bar toggle here
	new_order.bbcode_enabled = true # allow rich text tag formatting using BBCode tags
	new_order.set_text("[color=black]" + order_text + "[/color]")
	#new_order.set("theme_override_colors/font_color",Color.BLACK) # Color change for text in a Label node
	new_order_slip.add_child(new_order, true)
	new_order.set_anchors_preset(PRESET_TOP_LEFT)
	new_order.set_offset(SIDE_TOP, 14) #Set text within bounds of the order slip image
	new_order.set_offset(SIDE_LEFT, 25)
	#endregion ----------------------------------------
	order_labels.append(new_order)
	order_slips.append(new_order_slip)
	
	
	
	
func deliver_item(item: Food): #item_type means "burger" or "corndog" is_rat is bool
	var filled = false
	var order_text = ""
	
	var item_type: String = ""
	var is_rat: bool = false
	
	# Parse the item's type field
	match item.type:
		Global.Meals.BURGER:
			item_type = G_Level.BURGERS
			is_rat = false
		Global.Meals.CORN_DOG:
			item_type = G_Level.CORN_DOGS
			is_rat = false
		Global.Meals.RAT_BURGER:
			item_type = G_Level.BURGERS
			is_rat = true
		Global.Meals.RAT_DOG:
			item_type = G_Level.CORN_DOGS
			is_rat = true
			
	var ever_full = false
	for i in range(open_orders.size()):
		if filled or ever_full:
			break
		else:
			var ticket = open_orders[i]
			#var filled_order_num = 0
			if typeof(ticket) != TYPE_INT: # type int tickets are done tickets
				var want_more_burgers = ticket[G_Level.BURGERS_DONE]+ticket[G_Level.RAT_BURGERS_DONE] < ticket[G_Level.BURGERS]
				var want_more_corn_dogs = ticket[G_Level.CORN_DOGS_DONE]+ticket[G_Level.RAT_CORN_DOGS_DONE] < ticket[G_Level.CORN_DOGS]
				if item_type == G_Level.BURGERS:
					if want_more_burgers:
						if is_rat:
							ticket[G_Level.RAT_BURGERS_DONE] += 1
						else:
							ticket[G_Level.BURGERS_DONE] += 1
						filled = true
						ever_full = true
				elif item_type == G_Level.CORN_DOGS:
					if want_more_corn_dogs:
						if is_rat:
							ticket[G_Level.RAT_CORN_DOGS_DONE] += 1
						else:
							ticket[G_Level.CORN_DOGS_DONE] += 1
						filled = true
						ever_full = true
				else:
					print("ORDER SUBMITTED WITH NO BURGER OR CORN DOG OF TYPE: " + item_type)
				order_text = generate_order_text(ticket)
				want_more_burgers = ticket[G_Level.BURGERS_DONE]+ticket[G_Level.RAT_BURGERS_DONE] < ticket[G_Level.BURGERS]
				want_more_corn_dogs = ticket[G_Level.CORN_DOGS_DONE]+ticket[G_Level.RAT_CORN_DOGS_DONE] < ticket[G_Level.CORN_DOGS]
				var full = (not(want_more_burgers) and  not(want_more_corn_dogs))
				
				if full:
					order_success.emit(ticket)
					patience_timers[int(ticket[G_Level.ORDER_NUM])-1].queue_free() #complete order cean-up
				if (not full) and filled:
					var tween = get_tree().create_tween()
					tween.tween_property(order_slips[i], "modulate",Color(0.145, 0.812, 0.0, 1.0), 0.1)
					var modulate_timer = Timer.new()
					add_child(modulate_timer)
					modulate_timer.wait_time = 0.15
					modulate_timer.timeout.connect(unmodulate_asset.bind(order_slips[i],ticket))
					modulate_timer.start()
				order_slips[i].get_child(0).set_text("[color=black]" + order_text + "[/color]")
				
				
	if filled:
		item.queue_free() # Destroy the item if it was delivered
	else:
		return_item.emit(item)

func unmodulate_asset(slip,order):
	var want_more_burgers = order[G_Level.BURGERS_DONE]+order[G_Level.RAT_BURGERS_DONE] < order[G_Level.BURGERS]
	var want_more_corn_dogs = order[G_Level.CORN_DOGS_DONE]+order[G_Level.RAT_CORN_DOGS_DONE] < order[G_Level.CORN_DOGS]
	var full = (not(want_more_burgers) and  not(want_more_corn_dogs))
	if slip and typeof(slip) != 2 and not full:
		var tween = get_tree().create_tween()
		tween.tween_property(slip, "modulate",Color(1, 1,1, 1), 0.1)
	
func get_orders() -> Array:
	var order_array: Array
	# Filter orders from events
	for event in G_Level.Levels[Global.current_level]:
		if event[G_Level.EVENT_TYPE] == G_Level.TYPE_ORDER:
			order_array.append(event)
	order_array.sort_custom(G_Level.sort_events_accending)
	G_Level.add_indexes_to_event_array((order_array))
	return order_array
	
func generate_items_list(burger_count, corn_dog_count)-> String:
	var burger_pre_text = ""
	var burger_post_text = ""
	var burger_full_text = ""
	var corn_dog_pre_text = ""
	var corn_dog_post_text = ""
	var corn_dog_full_text = ""
	if burger_count >= 1:
		burger_pre_text = str(int(burger_count))+"x "
		corn_dog_pre_text = ", "
		if burger_count > 1:
			burger_post_text = "s"
		
		burger_full_text = burger_pre_text + "burger" + burger_post_text
	if corn_dog_count >= 1:
		corn_dog_pre_text += str(int(corn_dog_count))+"x "
		if corn_dog_count > 1:
			corn_dog_post_text = "s"
		corn_dog_full_text = corn_dog_pre_text + "corn dog" + corn_dog_post_text
	return burger_full_text + corn_dog_full_text
	
func generate_order_text(order):
	var order_num = int(order[G_Level.ORDER_NUM])
	#var order_items = order[G_Level.ORDER_ITEMS]
	var burger_count = order[G_Level.BURGERS] - order[G_Level.BURGERS_DONE] - order[G_Level.RAT_BURGERS_DONE]
	var corn_dog_count = order[G_Level.CORN_DOGS] - order[G_Level.CORN_DOGS_DONE] - order[G_Level.RAT_CORN_DOGS_DONE]
	var items_list = generate_items_list(burger_count,corn_dog_count)
	var leading_zero: String = "" 
	if order_num < 10:
		leading_zero = "0"
	var order_text = "# " + leading_zero + str(order_num) + "\n" + items_list
	return order_text
	
	
func _ready() -> void:
	orders = get_orders()
	order_success.connect(on_order_success)
	start_timers = create_order_timeline(orders)
	start_order_timers()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
