extends Label

@onready var timer = %LevelTimer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_left = (int(timer.get_time_left()))
	var minutes_left: int = int(time_left / 60)
	var seconds_left: int = time_left % 60
	var display_time = str(minutes_left) + ":" + str(seconds_left)
	set_text(display_time)
	pass
