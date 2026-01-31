class_name Rat
extends RigidBody2D

var direction_vector: Vector2 = Vector2.UP
signal die(rat: Rat)

@onready var sprite: AnimatedSprite2D = $Sprite

@export var rat_speed: int = 100
@export var rat_turn_speed: float = 0.5

func _ready():
	set_collision_layer_value(0, false)
	set_collision_layer_value(Global.RAT_LAYER, true)
	sprite.play()

func _physics_process(delta: float) -> void:
	var movement_vector: Vector2
	direction_vector = direction_vector.rotated(randf_range(-rat_turn_speed,rat_turn_speed))
	movement_vector = delta*direction_vector*rat_speed
	print("Rat moved",movement_vector)
	move_and_collide(movement_vector)

func _on_rat_interaction_zone_die() -> void:
	die.emit(self)
