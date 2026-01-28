extends Control

var orders: Array
var level_num = Global.current_level
var current_order_num: int = 0 #In practice, indexes from 1 to match meal order indexing
@onready var level_timer: Timer = %LevelTimer
@onready var order_panel: Panel = %OrderPanel
var order_slip_textures: Array

const ticket_height = 50

var start_timers: Array
var patience_timers: Array
var order_labels: Array

func start_next_order(_id): # _id counts as such: "Timer", "Timer2", etc. 
	current_order_num += 1
	var this_order = orders[current_order_num-1]
	var new_pateince_timer = Timer.new()
	self.add_child(new_pateince_timer)
	new_pateince_timer.name = "PatienceTimer" + str(current_order_num)
	new_pateince_timer.wait_time = this_order["patience"]
	new_pateince_timer.timeout.connect(_on_patience_timer_timeout.bind(new_pateince_timer.name,current_order_num))
	new_pateince_timer.one_shot = true
	new_pateince_timer.start()
	patience_timers.append(new_pateince_timer)
	self.display_next_order(this_order)
	print(this_order[G_Level.ORDER_TEXT])
	
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

func _on_patience_timer_timeout(timer_name, id):
	print("Customer " + str(id) + " ran out of patience! >:{")


func display_next_order(order):
	var new_order = Label.new()
	order_labels.append(new_order)
	var order_num = int(order[G_Level.ORDER_NUM])
	var order_items = order[G_Level.ORDER_ITEMS]
	var items_list = ""
	for item in order_items:
		items_list += ", " + item
	var leading_zero: String = ""
	if order_num < 10:
		leading_zero = "0"
	new_order.set_text("# " + leading_zero + str(order_num) + " - " + items_list)
	order_panel.add_child(new_order)
	new_order.set_anchors_preset(PRESET_TOP_RIGHT)
	new_order.set_offset(SIDE_TOP,  50 * (current_order_num-1))

	#new_order.set_position(Vector2(500, 100))
	#new_order.set_as_toplevel(true)
	
	
	
	
	
func _ready() -> void:
	#order_panel.set_offset(SIDE_TOP, 90)
	orders = G_Level.Levels[level_num]
	start_timers = create_order_timeline(orders)
	start_order_timers()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
