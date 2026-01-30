extends Control

signal order_success
signal order_fail
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
	print(this_order[G_Level.ORDER_TEXT])
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

func _on_patience_timer_timeout(timer_name, order_number):
	active_order_count -= 1
	open_orders[order_number-1] = 0 # When checking open orders, first check if typeof(open_orders[i]) == TYPE_INT: skip
	order_slips[order_number-1].set_texture(cross_out_image)
	#order_slips[order_number-1].set_modulate(Color(0.553, 0.102, 0.043, 1.0))
	var tween = get_tree().create_tween()
	tween.tween_property(order_slips[order_number-1], "modulate",Color(0.553, 0.102, 0.043, 1.0), 0.5)
	tween.tween_property(order_slips[order_number-1], "scale", Vector2(), 2)
	for i in range(order_number,order_slips.size()):
		if typeof(order_slips[i]) != TYPE_INT:
			print("poping #" + str(i))
			order_slips[i].set_position(order_slips[i].position + Vector2(0,-85)) 
	order_fail.emit(orders[order_number-1][G_Level.ORDER_SCORE])

func display_order(order):
	#region Create and display order slip
	var new_order_slip = TextureRect.new()
	new_order_slip.set_size(Vector2(200,80))
	new_order_slip.set_stretch_mode(5)
	new_order_slip.set_expand_mode(3)
	new_order_slip.set_texture(order_slip_image)
	order_panel.add_child(new_order_slip)
	new_order_slip.set_position(new_order_slip.position + Vector2(0,(85*(active_order_count-1))))
	#endregion --------------------------
	#region Order slip text formatting-----------------------------------------
	var order_num = int(order[G_Level.ORDER_NUM])
	var order_items = order[G_Level.ORDER_ITEMS]
	var items_list = ""
	#var burger_count = order[""]
	#var corn_dog_count = order
	for item in order_items:
		if items_list != "":
			items_list += ", " + item
		else:
			items_list = item #first item in list requires no leading comma
			
			
	var leading_zero: String = ""
	if order_num < 10:
		leading_zero = "0"
	var order_text = "# " + leading_zero + str(order_num) + "\n" + items_list
	#endregion ----------------------------------------------------------------
	#region Order slip text Object creation / formatting
	var new_order = RichTextLabel.new()
	new_order.size = Vector2(190+25,50+14)
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
	
	
	
	
func deliver_item(item_type): #item_type means burger or corndog, either beef or rat
	var filled = false
	for ii in range(0,open_orders.size()- 1):
		var ticket = open_orders[ii]
		var filled_order_num = 0
		if not filled:
			if typeof(ticket) != TYPE_INT:
				for i in range(0,ticket[G_Level.ORDER_ITEMS].size()-1):
					if not filled:
						if ticket[G_Level.ORDER_ITEMS][i] == item_type:
							ticket[G_Level.ORDER_ITEMS][i] = "*(" + ticket[G_Level.ORDER_ITEMS][i] + ")*"
							ticket[G_Level.ORDER_ITEM_DELIVERED] += 1
							if ticket[G_Level.ORDER_ITEM_DELIVERED] >= ticket[G_Level.ORDER_ITEMS].size():
								order_success.emit(ticket[G_Level.ORDER_SCORE])
								patience_timers[int(ticket[G_Level.ORDER_NUM])-1].queue_free() #complete order cean-up
							filled = true
							var items_list = ""
							for item in ticket[G_Level.ORDER_ITEMS]:
								if items_list != "":
									items_list += ", " + item
								else:
									items_list = item #first item in list requires no leading comma
							var leading_zero: String = ""
							if ticket[G_Level.ORDER_NUM] < 10:
								leading_zero = "0"
							var order_text = "#" + leading_zero + str(int(ticket[G_Level.ORDER_NUM])) + "\n" + items_list
							#order_slips[ii].get_child(0).set_text("# " + leading_zero + str(int(ticket[G_Level.ORDER_NUM])) + "\n" + items_list)
							order_slips[ii].get_child(0).set_text("[color=black]" + order_text + "[/color]")
							
	
func get_orders() -> Array:
	var order_array: Array
	# Filter orders from events
	for event in G_Level.Levels[Global.current_level]:
		if event[G_Level.EVENT_TYPE] == G_Level.TYPE_ORDER:
			order_array.append(event)
	order_array.sort_custom(G_Level.sort_events_accending)
	G_Level.add_indexes_to_event_array((order_array))
	return order_array
	
	
func _ready() -> void:
	orders = get_orders()
	print(":")
	start_timers = create_order_timeline(orders)
	start_order_timers()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
