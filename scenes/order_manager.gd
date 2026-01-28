extends Control

var orders: Array
var level_num = Global.current_level
var current_order_num: int = 0
@onready var order_window: PanelContainer = %OrderWindow
@onready var level_timer: Timer = %LevelTimer

func start_next_order():
	current_order_num += 1
	order_window.display_next_order(orders[current_order_num])
	
func set_order_timers(orders):
	var start_times: Array = []
	for order in orders:
		start_times.append(order[G_Level.ORDER_START_TIME]) # Create array of order start times
	start_times.sort() # Ensure order times are arranged earliest to latest
	level_timer.order_times = start_times

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	orders = G_Level.Levels[level_num]
	set_order_timers(orders)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
