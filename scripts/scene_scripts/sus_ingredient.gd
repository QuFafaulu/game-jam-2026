class_name SusIngredient
extends Ingredient

@onready var rot_progress: ProgressBar = $RotProgress

var is_rotting: bool = false
@export var rot_speed: float = 2.0

func _ready():
	super._ready()
	rot_progress.visible = false
	rot_progress.set_value_no_signal(100)

func _process(delta):
	if is_rotting:
		var new_rot_value = rot_progress.value - delta*rot_speed
		rot_progress.set_value_no_signal(new_rot_value)
	if rot_progress.value <= 0:
		self.queue_free() # Destroy self
		
func start_rotting():
	is_rotting = true
	rot_progress.visible = true
	
func stop_rotting():
	is_rotting = false
