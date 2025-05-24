extends Node2D

var playerSprite: Sprite2D
var radius: int = 32
func _ready() -> void:
	var size = radius * 2
	var img = Image.new()
	img = Image.create(size,size, false, Image.FORMAT_RGBA8)
	for x in size:
		for y in size:
			var dist = Vector2(x,y).distance_to(Vector2(radius, radius))
			if dist <= radius:
				img.set_pixel(x,y, Color.ORANGE_RED)
			else:
				img.set_pixel(x,y,Color(0,0,0,0))
	var txt = ImageTexture.new()
	txt = ImageTexture.create_from_image(img)
	var sprite = Sprite2D.new()
	sprite.position = Vector2(0,0)
	sprite.texture = txt
	add_child(sprite)

	
