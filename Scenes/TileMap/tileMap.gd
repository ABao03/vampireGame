class_name MyTileMap
extends Node2D

var playerPositionX = 1
var playerPositionY = 2

var mapWidthIndex = 8
var mapHeightIndex = 4


func _ready():
	updatePlayerPosition()


#region MANAGE PLAYER POSITION
func updatePlayerPosition() -> bool:
	if playerPositionX > mapWidthIndex || playerPositionX < 0:
		return false
	
	if playerPositionY > mapHeightIndex || playerPositionY < 0:
		return false
	
	
	var topLeftTile : Tile = $ColumnsContainer/Column/Tile
	
	var currentPlayerPosition = global_position
	
	for x in range(playerPositionX):
		currentPlayerPosition.x += topLeftTile.tileWidth + 5
	for y in range(playerPositionY):
		currentPlayerPosition.y += topLeftTile.tileHeight + 5
	currentPlayerPosition += topLeftTile.size / 2
	
	GlobalSignal.updatePlayerPosition.emit(currentPlayerPosition)
	
	return true
#endregion


#region RECEIVE INPUT SIGNALS
# called from GlobalInput
func movePlayerUp():
	if playerPositionY - 1 < 0:
		pass
	else:
		playerPositionY -= 1
		updatePlayerPosition()


func movePlayerDown():
	if playerPositionY + 1 > mapHeightIndex:
		pass
	else:
		playerPositionY += 1
		updatePlayerPosition()


func movePlayerLeft():
	if playerPositionX - 1 < 0:
		pass
	else:
		playerPositionX -= 1
		updatePlayerPosition()


func movePlayerRight():
	if playerPositionX + 1 > mapWidthIndex:
		pass
	else:
		playerPositionX += 1
		updatePlayerPosition()
#endregion


#region GLOBAL SIGNALS
func _on_tree_entered() -> void:
	GlobalSignal.wKeyPressed.connect(movePlayerUp)
	GlobalSignal.aKeyPressed.connect(movePlayerLeft)
	GlobalSignal.sKeyPressed.connect(movePlayerDown)
	GlobalSignal.dKeyPressed.connect(movePlayerRight)


func _on_tree_exited() -> void:
	GlobalSignal.wKeyPressed.disconnect(movePlayerUp)
	GlobalSignal.aKeyPressed.disconnect(movePlayerLeft)
	GlobalSignal.sKeyPressed.disconnect(movePlayerDown)
	GlobalSignal.dKeyPressed.disconnect(movePlayerRight)
#endregion
