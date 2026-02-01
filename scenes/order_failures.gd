extends ProgressBar

@export var refill_speed: float = .5
signal orders_failed

func _ready():
	value = 100

func _process(delta):
	if value <= 0.5:
		orders_failed.emit()
	if value < 100:
		self.set_value_no_signal(value + delta*refill_speed)
