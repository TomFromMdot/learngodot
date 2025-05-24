extends Node2D


#THIS IS SOMETHING EXTRA
#MY OWN STADUIM SYSTEM
#ALL RIGHT RESERVER FUCK OFF


#Stadium will be typical node2d

	
class_name Stadium
#Now magic happend..
#Stadium will be a grid system so we need grid array
#And gride size. x.y



var gridArray = []
var gridSize: Vector2i

var gridFromXml = []

# Stadium example
#	[X,X,X,X,X]
#	[B,X,X,X,B]
#	[X,X,X,X,B]
# X = Grass
# B = BRAMKA
#
#
enum GridType {
	NONE = 0,
	GRASS = 1,
	LINE= 2
}



func _init(size: Vector2i) -> void:
	gridSize = size
	

	
#Dobrze wiedzieć jak parsować jakieś dane z pliku np xml
func readGridFromXmlandCreateGrid(url: String):
	var parser = XMLParser.new()
	parser.open(url)
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			var attr = {}
			for idx in range(parser.get_attribute_count()):
				attr[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
			print("The ", node_name, " element ", attr)
				
	
#Dynamicznie... Jedna MOJA procedura która działa tak jak ja chce...
func createDynamic(pos: Vector2i, type: GridType) -> Sprite2D:
	
	print("Create primitve sprite")
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	#Pierwsza myśl po zobaczeniu tego "Switcha"...
	#Referencja będzie lepsza...
	#Ulepsze to w innej funkcji....
	match type:
		0:
			print("Create None...")
			image.fill(Color.BLACK)
		1:
			print("Create Grass...")
			image.fill(Color.GREEN)
		2: 
			print("Create Whie Line")
			image.fill(Color.WHITE)
			
	var texture = ImageTexture.create_from_image(image)
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.position = pos
	return sprite

# Dodałem to pózniej następne procedury wytłumaczą...
func setColorByGridType(type: GridType, image: Image):
	
	#image - to referencja
	#referencja oznacza - Bierzemy za fraki zmienną mówimy jej wprost masz być taka jak ustale w funkcji  ;>>
	# ustawiamy kolor na czymś co wpadnie przez argument w typ wypadkmu Image...
	
	match type:
		0:
			print("Create None...")
			image.fill(Color.BLACK)
		1:
			print("Create Grass...")
			image.fill(Color.GREEN)
		2: 
			print("Create Whie Line")
			image.fill(Color.WHITE)

# createDynamic był zbyt brzydki więc powstał pomysł na zrobienie czegoś lepszego...
func createDynamicv2(pos: Vector2i, type: GridType) -> Sprite2D:
	print("Create dynamic sprite")
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	
	# Zajebista C jednak uczy dobrze
	# Wygląda to super w dodatku goal bo podzieliliśmy odpowiedzialność na inne fragmęty....
	# Może refaktoryzacja ?
	# Jade..
	setColorByGridType(type, image)
	var texture = ImageTexture.create_from_image(image)
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.position = pos
	return sprite


# ================================================================
# ==           SECTION: Programowanie Proceduralne              ==
# ==                        OPIS                                ==
# ==   Język C nie miał obiektów {} czy class, nie miał nic     ==
# == Często pisało się w nim proceduralnie budując logikę       ==
# ================================================================
# To procedura która wykona kilka małych procedur dając duży efekt końcowy...


func buildDynamicElement(pos: Vector2i, type: GridType):
	var image
	var texture
	var sprite
	buildDynamicImage(image)
	buildDynamicSetColorByType(type, image)
	buildDynamicTexture(texture, image)
	sprite = buildDynamicSprite(pos, texture)
	addToGrid(gridArray, sprite)
#Funkcje budujące



func buildDynamicImage(obj):
	obj = Image.create(32,32,false, Image.FORMAT_RGB8)


func buildDynamicSetColorByType(type: GridType, image: Image):
	match type:
		0:
			print("Create None...")
			image.fill(Color.BLACK)
		1:
			print("Create Grass...")
			image.fill(Color.GREEN)
		2: 
			print("Create Whie Line")
			image.fill(Color.WHITE)
			
			
func buildDynamicTexture(obj, image: Image):
	obj = ImageTexture.create_from_image(image)
	
	
func buildDynamicSprite(pos: Vector2i, txt: Texture2D) -> Sprite2D:
	var tmp = Sprite2D.new()
	tmp.position = pos
	tmp.texture = txt
	return tmp
	
	
func addToGrid(arr: Array, sprite: Sprite2D):
	arr.push_back(sprite)


# ================================================================
# ==         SECTION: Programowanie Proceduralne END            ==
# ================================================================

func createGrass(pos: Vector2i) -> Sprite2D:
	print("Create primitve sprite")
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color.GREEN)
	var texture = ImageTexture.create_from_image(image)
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.position = pos
	return sprite

func createWhiteLine(pos: Vector2i) -> Sprite2D:
	print("Create primitve sprite")
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color.WHITE)
	var texture = ImageTexture.create_from_image(image)
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.position = pos
	return sprite

func createStadium():
	if gridSize.x == 0 or gridSize.y == 0:
		print("U need to define first a size. Cant be 0,0")
		return
	for y in range(gridSize.y):
		for x in range(gridSize.x):
			var debugLog = "Create grid with x: %s y: %s"
			var formatedLog = debugLog % [x,y]
			
			gridArray.push_back(createGrass(Vector2i(x * 32 ,y * 32))) 

func addAllChild():
	if gridSize.x == 0 or gridSize.y == 0:
		print("U need to define first a size. Cant be 0,0")
		return
	for el in gridArray:
		print("Add child...")
		add_child(el)

class Grid:
	var _posx: int
	var _posy: int
	var _type: GridType
	func _init(pos: Vector2i, type: GridType) -> void:
		_posx = pos.x
		_posy = pos.y
		_type = type

# Ale się rozpierdol zrobił... XD
# Musze to jakoś ładnie opakować...
# Skopiuje procedury 

func createNewStyleStadium():
	var polishStadium = StadiumCreator.new("Polski stadion", 10, 10)
	polishStadium.buildStadium("Polski stadion")
	var grid = polishStadium.getStadiumData()
	for el in grid:
		add_child(el)

class StadiumCreator:

	#Obiekt musi mieć swój własny grid array nie chcemy globalnych zmiennych które są blee.
	#Dodam stringa gdyby stadiony miały mieć później swoje nazwy aby je wyszukać czy coś...
	var stadiumName: String
	var grid : Array
	var size : Vector2i
	func _init(name: String, sizeX: int, sizeY: int) -> void:
		stadiumName = name
		size = Vector2i(sizeX, sizeY)
		
	func buildDynamicElement(pos: Vector2i, type: GridType):
		var image
		var texture
		var sprite
		buildDynamicImage(image)
		buildDynamicSetColorByType(type, image)
		buildDynamicTexture(texture, image)
		sprite = buildDynamicSprite(pos, texture)
		addToGrid(grid, sprite) # Ta procedura w poprzedniej wersji używała jakiejś tablicy globalnej teraz ma own array...
	#Funkcje budujące



	func buildDynamicImage(obj):
		obj = Image.create(32,32,false, Image.FORMAT_RGB8)


	func buildDynamicSetColorByType(type: GridType, image: Image):
		match type:
			0:
				print("Create None...")
				image.fill(Color.BLACK)
			1:
				print("Create Grass...")
				image.fill(Color.GREEN)
			2: 
				print("Create Whie Line")
				image.fill(Color.WHITE)
				
				
	func buildDynamicTexture(obj, image: Image):
		obj = ImageTexture.create_from_image(image)
		
		
	func buildDynamicSprite(pos: Vector2i, txt: Texture2D) -> Sprite2D:
		var tmp = Sprite2D.new()
		tmp.position = pos
		tmp.texture = txt
		return tmp
		
		
	func addToGrid(arr: Array, sprite: Sprite2D):
		arr.push_back(sprite)
	
	#Mamy tworzenie Sprita i dodawanie go do tablicy...
	#Potrzebujemy mechanizmu budowy
	
	
	
# ================================================================
# ==           SECTION: ŁADOWANIE XML I TWORZENIE GRIDA         ==
# ================================================================


# error_code = wysterujemy tym błędy w procedurze.
# jeśli jest inne niż 0 nie przechodzimy przez następne procedury
	func setXMLParser(url: String, error_code: int) -> XMLParser:
		var obj = XMLParser.new()
		error_code = 0
		if obj.open(url) != OK:
			error_code = 1
			push_error("XML load error... in settin parser")
		return obj
	func buildArrayFromXML(obj: XMLParser, error_code: int):
		if error_code != 0:
			return
		while obj.read() == OK:
			if obj.get_node_type() == XMLParser.NODE_ELEMENT and obj.get_node_name() == "Grid":
				var x = int(obj.get_named_attribute_value("x"))
				var y = int(obj.get_named_attribute_value("y"))
				var t = int(obj.get_named_attribute_value("type"))
				# i teraz wlatuje nasz Dynamic builder
				buildDynamicElement(Vector2i(x,y), t)
		
		
		
# ================================================================
# ==       SECTION: ŁADOWANIE XML I TWORZENIE GRIDA END         ==
# ================================================================

	func buildStadium(url: String):
		var parser
		var error: int
		parser = setXMLParser("res://Stadium.xml", error)
		buildArrayFromXML(parser, error)
	func getStadiumData() -> Array:
		return grid
				
