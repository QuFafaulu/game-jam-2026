class_name EventManager
extends Control

var events: Array
var start_timers: Array
var current_event_num: int

signal request_restock
signal request_critter_spawn


func create_event_timeline(orders) -> Array:
	var timer_array: Array
	for order in orders:
		var start_time
		start_time = order[G_Level.ORDER_START_TIME]
		var new_timer = Timer.new()
		new_timer.wait_time = start_time
		timer_array.append(new_timer)
	return timer_array


func get_events() -> Array:
	var event_array: Array
	# Filter orders from events
	for event in G_Level.Levels[Global.current_level]:
		if event[G_Level.EVENT_TYPE] == G_Level.TYPE_RESTOCK or event[G_Level.EVENT_TYPE] == G_Level.TYPE_CRITTER_SPAWN:
			event_array.append(event)
	event_array.sort_custom(G_Level.sort_events_accending)
	G_Level.add_indexes_to_event_array((event_array)) # no need to index non-order events
	return event_array

func create_order_timeline(events) -> Array:
	var timer_array: Array
	for event in events:
		var start_time
		start_time = event[G_Level.START_TIME]
		var new_timer = Timer.new()
		new_timer.name = "Timer" + str(int(event[G_Level.INDEX]))
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
	
func _on_start_timer_timeout(timer_name):
	start_next_event(timer_name)
	
func start_next_event(_timer_name):
	current_event_num += 1
	var this_event = events[current_event_num-1]
	if this_event[G_Level.EVENT_TYPE] == G_Level.TYPE_RESTOCK:
		var amount_requested = this_event[G_Level.RESTOCK]
		request_restock.emit(amount_requested)
	elif this_event[G_Level.EVENT_TYPE] == G_Level.TYPE_CRITTER_SPAWN:
		var amount_requested = this_event[G_Level.TYPE_CRITTER_SPAWN]
		var critter_type = G_Level.RATS # EXPANDABLE TO ACCEPT OTHER CRITTER TYPES
		request_critter_spawn.emit(amount_requested,critter_type)

	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	events = get_events()
	start_timers = create_order_timeline(events)
	start_order_timers()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
