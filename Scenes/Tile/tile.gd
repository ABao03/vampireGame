class_name Tile
extends ColorRect

var tileWidth = size.x
var tileHeight = size.y


func _on_resized() -> void:
	tileWidth = size.x
	tileHeight = size.y
