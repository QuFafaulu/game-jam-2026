extends ColorRect

var is_fading_failure: bool = false;
var is_fading_victory: bool = false;
@onready var fade_timer = $FadeTimer

func _process(delta):
	if is_fading_failure or is_fading_victory:
		modulate.a = 1.0 - fade_timer.time_left / fade_timer.wait_time
