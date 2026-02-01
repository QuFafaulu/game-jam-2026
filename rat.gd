class_name Rat
extends RigidBody2D

var direction_vector: Vector2 = Vector2.UP
signal die(rat: Rat)

enum RatStates {EXPLORING, LEAVING}

var state: RatStates = RatStates.EXPLORING

@onready var sprite: AnimatedSprite2D = $Sprite

@export var rat_speed: int = 100
@export var rat_turn_speed: float = 0.5
@onready var leave_timer: Timer = $LeaveTimer

var exit_node: Node2D = null

func _ready():
	set_collision_layer_value(0, false)
	set_collision_layer_value(Global.RAT_LAYER, true)
	sprite.play()

func _physics_process(delta: float) -> void:
	var movement_vector: Vector2
	
	match state:
		RatStates.EXPLORING:
			direction_vector = direction_vector.rotated(randf_range(-rat_turn_speed,rat_turn_speed))
		RatStates.LEAVING:
			direction_vector = self.global_transform.origin.direction_to(exit_node.global_transform.origin)
			if self.global_transform.origin.distance_to(exit_node.global_transform.origin) < 20:
				self.queue_free()

	movement_vector = delta*direction_vector*rat_speed
	move_and_collide(movement_vector)

func _on_rat_interaction_zone_die() -> void:
	die.emit(self)


func _on_leave_timer_timeout() -> void:
	rat_speed = rat_speed*5
	state = RatStates.LEAVING
