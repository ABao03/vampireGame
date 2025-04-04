class_name Tile
extends ColorRect

var tilePositionX : int
var tilePositionY : int

var tileWidth = size.x
var tileHeight = size.y

var defaultColor = Color(201, 201, 201, 255)
var playerMoveTileColor = Color(169, 0, 0, 255)
var bulletTileColor = Color(0, 134, 255, 255)


#region SET TILE COLOR
func setTileAsPlayerMoveTile():
	color = playerMoveTileColor


func setTileAsBulletTile():
	color = bulletTileColor


func setTileAsDefaultColor():
	color = defaultColor
#endregion


#region GET ANCHOR
func getAnchor():
	return $TileAnchor
#endregion
