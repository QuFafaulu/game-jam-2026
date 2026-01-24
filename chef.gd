extends CharacterBody2D

@export var move_speed := 500
@onready var interaction_zone = $Interaction_zone

var carried_item: Sprite2D

signal is_interacting

func get_input():
	var input_dir: Vector2
	input_dir = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = input_dir * move_speed
	
func _physics_process(delta):
	get_input()
	move_and_slide()
	#move_and_collide(velocity*delta)
	
func _input(event):
	if Input.is_action_just_pressed("interact"):
		is_interacting.emit(interaction_zone.get_overlapping_areas())

func pick_up_item(item: Sprite2D):
	add_child(item)
	item.move_local_y(-20)
	carried_item = item
