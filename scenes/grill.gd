extends Station

var sprite_child
var my_texture = preload("uid://dirqwushnq8jd")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_child = find_child("Sprite2D")
	sprite_child.texture = my_texture
	#self.scale = Vector2(3,3)
	#print(sprite_child.texture.scale)# = Vector2(.3,.3)//
	sprite_child.scale = Vector2(.2,.2)
	sprite_child.position += Vector2(-6, -5)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
