extends Node2D


func _ready() -> void:
	var _stadium = Stadium.new(Vector2i(2,2))
	
	_stadium.createNewStyleStadium()
