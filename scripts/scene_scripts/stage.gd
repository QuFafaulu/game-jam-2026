extends Node2D

@onready var chef = $Chef
@onready var dropped_items = $DroppedItems
@onready var order_manager = $OrderManager
@onready var delivery_window = $Interactable_objects/DeliveryWindow
@onready var rat_spawn = $RatSpawn
@onready var rat_exit = $RatExit
@onready var fridge: Fridge = $Interactable_objects/Fridge
@onready var rat_death_sound: AudioStreamPlayer2D = $Sounds/RatDeathSound
@onready var rat_spawn_sound: AudioStreamPlayer2D = $Sounds/RatSpawnSound
@onready var speach_bubble: RichTextLabel = $SpeachBubble
@onready var speach_bubble_sprite: Sprite2D = $SpeachBubbleSprite
@onready var order_failures: ProgressBar = $OrderFailures
@onready var fade_rect: ColorRect = $FadeRect
@onready var fade_timer: Timer = $FadeRect/FadeTimer

var speach_bubble_buffer: Array[String]

const SUS_INGREDIENT_SCENE: PackedScene = preload("res://scenes/sus_ingredient.tscn")
const RAT_SCENE: PackedScene = preload("res://scenes/rat.tscn")

signal victory_screen
signal failure_screen

func _ready():
	speach_bubble_sprite.visible = false
	speach_bubble.add_theme_color_override("default_color",Color("black"))
	speach_bubble.add_theme_font_size_override("normal_font_size",24)

# When the chef drops an item, reparent that item to self (the stage)
# and enable its interaction so the chef or others can pick it up again
func _on_chef_drop(item: Item) -> void:
	# Claim the dropped item, and put it under the dropped_items node
	item.reparent(dropped_items)
	# Allow the item to be interacted with
	item.enable_interaction()
	# Set the item's position back to it's position before reparenting
	# (this should leave the item unmoved)
	item.position = chef.position

func _on_delivery_window_deliver_item(item: Food) -> void:
	order_manager.deliver_item(item)

func _on_order_manager_return_item(item: Item) -> void:
	# Claim the dropped item, and put it under the dropped_items node
	item.reparent(dropped_items)
	# Allow the item to be interacted with
	item.enable_interaction()
	# Set the item's position to just under the delivery window
	item.position = delivery_window.position + Vector2(0, 50)

func _on_rat_die(rat: Rat) -> void:
	var dead_rat: SusIngredient = SUS_INGREDIENT_SCENE.instantiate()
	dropped_items.add_child(dead_rat)
	dead_rat.scale = Vector2(4.0,4.0)
	dead_rat.position = rat.position
	dead_rat.type = Global.Ingredients.RAT
	dead_rat.sprite.texture = load(Global.INGREDIENT_SPRITES[dead_rat.type])
	dead_rat.set_interact_area()
	dead_rat.start_rotting()
	dead_rat.enable_interaction()
	rat.queue_free()
	rat_death_sound.play()

func spawn_rat(wait_time: int):
	var rat: Rat = RAT_SCENE.instantiate()
	print("rat spawned")
	self.add_child(rat)
	#rat.scale = Vector2(4.0,4.0)
	rat.position = rat_spawn.position
	rat.die.connect(_on_rat_die)
	if wait_time == 0:
		rat.leave_timer.wait_time = randi_range(10,25);
	else:
		rat.leave_timer.wait_time = wait_time
	rat.leave_timer.start()
	rat.exit_node = rat_exit
	rat_spawn_sound.play()

func _on_event_manager_request_critter_spawn(number: int, _type: String, duration: int) -> void:
	for i in range(number):
		spawn_rat(duration)

func _on_event_manager_request_restock(amount: int) -> void:
	for i in range(amount):
		fridge.spawn_beef()

func _on_order_manager_display_speach_bubble(text: String) -> void:
	if not speach_bubble.is_displaying_text:
		start_speach_bubble(text)
	else:
		speach_bubble_buffer.push_back(text)
	
func start_speach_bubble(text: String):
	speach_bubble.visible = true
	speach_bubble_sprite.visible = true
	speach_bubble.display_text(text)

func _on_speach_bubble_text_done() -> void:
	if not speach_bubble_buffer.size() == 0:
		start_speach_bubble(speach_bubble_buffer.pop_back())
	else:
		speach_bubble_sprite.visible = false
		speach_bubble.visible = false

func _on_order_manager_level_over() -> void:
	fade_rect.is_fading_victory = true
	fade_timer.start()

func _on_order_manager_punish_player() -> void:
	order_failures.value -= 40
	
func _on_order_failures_orders_failed() -> void:
	fade_rect.is_fading_failure = true
	fade_timer.start()

func _on_fade_timer_timeout() -> void:
	if fade_rect.is_fading_failure:
		failure_screen.emit()
	else:
		victory_screen.emit()
