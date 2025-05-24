extends Node2D

class_name Builder

var gridType = {NONE = 0, GRASS = 1, WHITE = 2}
var gridData: StadiumData
var gridSprites: Array
func loadStadiumFromXml(url: String) -> StadiumData:
	var result = StadiumData.new()
	var parser = XMLParser.new()
	if parser.open(url) != OK:
		push_error("Failed load xml file...")
		return result
	
	while parser.read() == OK:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT and parser.get_node_name() == "Stadium":
			result.WIDTH = int(parser.get_named_attribute_value("width"))
			result.HEIGHT = int(parser.get_named_attribute_value("height"))
			result.TILESET = int(parser.get_named_attribute_value("tile_size"))
		if parser.get_node_type() == XMLParser.NODE_ELEMENT and parser.get_node_name() == "Grid":
			var el = {
			"x" : int(parser.get_named_attribute_value("x")),
			"y" : int(parser.get_named_attribute_value("y")),
			"t" : int(parser.get_named_attribute_value("type")),
			}
			result.DATA.push_back(el)
	return result
func createSprite(pos: Vector2i, type: int) -> Sprite2D:
	
	print("Create primitve sprite")
	var image = Image.create(16, 16, false, Image.FORMAT_RGBA8)
	#Pierwsza myśl po zobaczeniu tego "Switcha"...
	#Referencja będzie lepsza...
	#Ulepsze to w innej funkcji....
	match type:
		0:
			image.fill(Color(0.0, 0.0, 0.0))      # OUTSIDE
		1:
			image.fill(Color(0.51, 0.76, 0.51))   # GRASS_LIGHT
		2:
			image.fill(Color(0.31, 0.56, 0.31))   # GRASS_DARK
		3:
			image.fill(Color(1.0, 1.0, 1.0))      # LINE
		4:
			image.fill(Color(0.42, 0.66, 0.42))   # AREA_SHADE

		5:
			image.fill(Color(0.9, 0.9, 0.9))      # GOAL_POST
		6:
			image.fill(Color(0.8, 0.8, 0.8))      # NET_SHADING
		7:
			image.fill(Color(1.0, 1.0, 1.0))      # CORNER_ARC
		8:
			image.fill(Color(0.7, 0.7, 0.7))      # PENALTY_ARC
		9:
			image.fill(Color(1.0, 1.0, 1.0))      # CENTER_CIRCLE

		10:
			image.fill(Color(1.0, 1.0, 1.0))      # CENTER_SPOT
		11:
			image.fill(Color(1.0, 1.0, 1.0))      # PENALTY_SPOT
		12:
			image.fill(Color(0.6, 0.6, 0.6))      # TECHNICAL_AREA
		13:
			image.fill(Color(0.5, 0.5, 0.5))      # BENCH_AREA
		14:
			image.fill(Color(0.4, 0.4, 0.4))      # COACH_ZONE

		15:
			image.fill(Color(0.2, 0.2, 0.8))      # AD_BOARDS
		16:
			image.fill(Color(0.8, 0.2, 0.2))      # SPONSOR_LOGO
		17:
			image.fill(Color(1.0, 1.0, 0.0))      # STADIUM_NAME
		18:
			image.fill(Color(0.9, 0.9, 0.6))      # VAR_AREA
		19:
			image.fill(Color(0.3, 0.3, 0.3))      # DUGOUT

		20:
			image.fill(Color(0.8, 0.8, 0.8))      # LINE_SHADOW
		21:
			image.fill(Color(0.1, 0.1, 0.1))      # CROWD_AREA
		22:
			image.fill(Color(0.9, 0.5, 0.0))      # BENCH_LINE
		23:
			image.fill(Color(0.7, 0.7, 0.0))      # SUBSTITUTION_ZONE
		24:
			image.fill(Color(0.0, 0.5, 0.0))      # WATER_ZONE

		25:
			image.fill(Color(0.3, 0.6, 0.3))      # SHADOW_GRASS_1
		26:
			image.fill(Color(0.35, 0.65, 0.35))   # SHADOW_GRASS_2
		27:
			image.fill(Color(0.4, 0.7, 0.4))      # SHADOW_GRASS_3
		28:
			image.fill(Color(0.45, 0.75, 0.45))   # SHADOW_GRASS_4
		29:
			image.fill(Color(0.5, 0.8, 0.5))      # SHADOW_GRASS_5

		_:
			image.fill(Color(1.0, 0.0, 1.0))      # UNKNOWN / DEBUG


	var texture = ImageTexture.create_from_image(image)
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.position = pos
	return sprite

func createOneBigTexture(stadium: StadiumData, rectSize: int) -> Sprite2D:
	var stadiumInfo = "Stadium size. Width: %d | Height: %d" % [stadium.WIDTH, stadium.HEIGHT]
	print(stadiumInfo)
	var img:Image
	img = Image.create(stadium.WIDTH * rectSize, stadium.HEIGHT * rectSize, false, Image.FORMAT_RGBA8)
	print(img.get_size())
	var elementsCount = 0 as int
	for i in gridData.DATA:
		
		var tmpImage = Image.create(rectSize, rectSize, false, Image.FORMAT_RGBA8) as Image
		tmpImage.fill(getColor(i["t"]))
		var x = tmpImage.get_used_rect()
		img.blit_rect(tmpImage, x, Vector2(i["x"] * rectSize, i["y"] * rectSize))
		elementsCount += 1
	print(elementsCount)
	var texture = ImageTexture.create_from_image(img)
	var sprite = Sprite2D.new()
	sprite.position = Vector2(100, 100)
	sprite.texture = texture
	print("Created txt...\n")
	return sprite
		
func getColor(type: int) -> Color:
	match type:
		0:
			return Color(0.0, 0.0, 0.0)      # OUTSIDE
		1:
			return Color(0.51, 0.76, 0.51)   # GRASS_LIGHT
		2:
			return Color(0.31, 0.56, 0.31)   # GRASS_DARK
		3:
			return Color(1.0, 1.0, 1.0)      # LINE
		4:
			return Color(0.42, 0.66, 0.42)   # AREA_SHADE

		5:
			return Color(0.9, 0.9, 0.9)      # GOAL_POST
		6:
			return Color(0.8, 0.8, 0.8)      # NET_SHADING
		7:
			return Color(1.0, 1.0, 1.0)      # CORNER_ARC
		8:
			return Color(0.7, 0.7, 0.7)      # PENALTY_ARC
		9:
			return Color(1.0, 1.0, 1.0)      # CENTER_CIRCLE

		10:
			return Color(1.0, 1.0, 1.0)      # CENTER_SPOT
		11:
			return Color(1.0, 1.0, 1.0)      # PENALTY_SPOT
		12:
			return Color(0.6, 0.6, 0.6)      # TECHNICAL_AREA
		13:
			return Color(0.5, 0.5, 0.5)      # BENCH_AREA
		14:
			return Color(0.4, 0.4, 0.4)      # COACH_ZONE

		15:
			return Color(0.2, 0.2, 0.8)      # AD_BOARDS
		16:
			return Color(0.8, 0.2, 0.2)      # SPONSOR_LOGO
		17:
			return Color(1.0, 1.0, 0.0)      # STADIUM_NAME
		18:
			return Color(0.9, 0.9, 0.6)      # VAR_AREA
		19:
			return Color(0.3, 0.3, 0.3)      # DUGOUT

		20:
			return Color(0.8, 0.8, 0.8)      # LINE_SHADOW
		21:
			return Color(0.1, 0.1, 0.1)      # CROWD_AREA
		22:
			return Color(0.9, 0.5, 0.0)      # BENCH_LINE
		23:
			return Color(0.7, 0.7, 0.0)      # SUBSTITUTION_ZONE
		24:
			return Color(0.0, 0.5, 0.0)      # WATER_ZONE

		25:
			return Color(0.3, 0.6, 0.3)      # SHADOW_GRASS_1
		26:
			return Color(0.35, 0.65, 0.35)   # SHADOW_GRASS_2
		27:
			return Color(0.4, 0.7, 0.4)      # SHADOW_GRASS_3
		28:
			return Color(0.45, 0.75, 0.45)   # SHADOW_GRASS_4
		29:
			return Color(0.5, 0.8, 0.5)      # SHADOW_GRASS_5

		_:
			return Color(1.0, 0.0, 1.0)      # UNKNOWN / DEBUG
class StadiumData:
	var WIDTH: int
	var HEIGHT: int
	var TILESET: int
	var DATA: Array
	# TODO 
	# ADD TO DATA 3 NEW NODES WHICH WILL BE A LAYERS
	# CREATE LAYERS
	# GROUND
	# LINE_GROUND
	# LINE_BLOCK
	
	# THEN WE CAN MAKE 4 OTHER TYPES OF OBJECTS
	# WHICH CAN REPRESENT FEW PARTS OF STADIUM
	# MOST IMPORTANT THINK IS 
	# LINE_BLOCK => SPRITE WITH COLISION
func _ready() -> void:
	gridData = loadStadiumFromXml("res://stadiums/stadium_extra_modified.xml")
	var stadium = createOneBigTexture(gridData, 8)
	add_child(stadium)
