extends RichTextLabel

var visible_character_count: float = 0
var is_displaying_text = false
@export var fill_speed: float = 10
@export var hang_time: float = 20
signal text_done

func display_text(order_text: String):
	text = order_text
	visible_characters = 0
	visible_character_count = 0
	is_displaying_text = true
	
func _process(delta):
	visible_character_count += delta*fill_speed
	visible_characters = round(visible_character_count)
	if visible_character_count >= text.length() + hang_time:
		is_displaying_text = false
		text_done.emit()
