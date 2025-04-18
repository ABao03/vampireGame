class_name MyTileMap
extends Node2D

@onready var player: Player = get_tree().get_first_node_in_group("Player")
var playerPositionX : int = 1
var playerPositionY : int = 2

const NORTH : Vector2 = Vector2(0,1)
const EAST : Vector2 = Vector2(1,0)
const WEST : Vector2 = Vector2(-1,0)
const SOUTH : Vector2 = Vector2(0,-1)

var gunSelected = false

var bulletTilesOrigin: Vector2
var bulletTilesOriginOrientation = WEST
var bulletTilesArray: Array
var bulletTileRepetitions: int 

var playerMoveTilesOrigin: Vector2
var playerMoveTilesOriginOrientation = EAST
var playerMoveTilesArray: Array
var playerMoveTileRepetitions : int

var playerMoveTilesPath: Array[Tile]
var playerMovementConfirmed: bool = false
var playerStopAnimationPlayed: bool = true

var tilesContainingEnemies: Array[Vector2]

var mapWidthIndex = 8
var mapHeightIndex = 4

var enemyPositionsRelativeToPlayer: Array


#region INITIALIZE TILE MAP
func _ready():
	setTileXAndYPositions()
	call_deferred("setInitialPlayerPosition")


func setInitialPlayerPosition():
	var spawnTile: Tile = getSpecificTile(playerPositionX, playerPositionY)
	player.setPlayerPosition(spawnTile.getAnchor().global_position)


func setTileXAndYPositions():
	var columnX = 0
	var tileY = 0
	
	var columnsContainer = $ColumnsContainer
	
	for column in columnsContainer.get_children():
		
		for tile : Tile in column.get_children():
			tile.tilePositionX = columnX
			tile.tilePositionY = tileY
			tileY += 1
		
		tileY = 0
		columnX += 1
#endregion


#region MOVE PLAYER 
func _process(_delta: float) -> void:
	if playerMoveTilesPath.is_empty() == false:
		var moveTarget : Tile = playerMoveTilesPath[len(playerMoveTilesPath) - 1]
		
		var moveTargetAnchor = moveTarget.getAnchor()
		var playerAnchor = player.getAnchor()
		
		if playerMovementConfirmed:
			player.movePlayerTowardsPosition(moveTargetAnchor.global_position)
			
			if playerStopAnimationPlayed == false && (moveTargetAnchor.global_position.round() - playerAnchor.global_position.round()).length() < 75:
				playerStopAnimationPlayed = true
				GlobalSignal.playerStoppedMotion.emit()
			
			if moveTargetAnchor.global_position.round() == playerAnchor.global_position.round():
				playerPositionX = moveTarget.tilePositionX
				playerPositionY = moveTarget.tilePositionY
				playerMoveTilesPath.clear()
				playerMovementConfirmed = false
				GlobalSignal.enableMovementInput.emit()
				# erase one specific tile if you want to move based on the grid
		else:
			player.setPlayerFacing(moveTargetAnchor)
#endregion


#region SET ENEMY POSITION
# called from enemySpawner
func spawnEnemyOnTile(xPosition: int, yPosition: int):
	var spawnTile: Tile = getSpecificTile(xPosition, yPosition)
	tilesContainingEnemies.append(Vector2(xPosition, yPosition))
	
	var spawnPosition: Vector2 = spawnTile.getAnchor().global_position
	GlobalSignal.setEnemyPosition.emit(spawnPosition)
#endregion


#region CHECK IF ENEMY PRESENT
func checkIfTileHasEnemy(xPosition: int, yPosition: int) -> bool:
	if tilesContainingEnemies.has(Vector2(xPosition, yPosition)):
		return true
	else:
		return false
#endregion


#region DRAW PATTERNS ON TILEMAP
func drawGunTilesPattern(gunResource : GunResource):
	gunSelected = true
	clearGunTiles()
	
	createArrayOfTilesFromGunResource(gunResource)
	drawBulletTiles()
	drawPlayerMoveTiles()


func createArrayOfTilesFromGunResource(gunResource: GunResource):
	bulletTilesArray = gunResource.bulletTiles
	bulletTileRepetitions = gunResource.bulletTilesRepetitions
	
	playerMoveTilesArray = gunResource.playerMoveTiles
	playerMoveTileRepetitions = gunResource.playerMoveTilesRepetitions


func drawBulletTiles():
	getBulletTilesOrigin()
	
	for repetitions in range(bulletTileRepetitions + 1):
		var bulletTileXOffset
		var bulletTileYOffset
		
		for bulletTile in bulletTilesArray:
			if bulletTilesOriginOrientation == NORTH:
				bulletTileXOffset = bulletTile[1]
				bulletTileYOffset = bulletTile[0] * -1
			elif bulletTilesOriginOrientation == EAST:
				bulletTileXOffset = bulletTile[0] * -1
				bulletTileYOffset = bulletTile[1]
			elif bulletTilesOriginOrientation == SOUTH:
				bulletTileXOffset = bulletTile[1]
				bulletTileYOffset = bulletTile[0]
			elif bulletTilesOriginOrientation == WEST:
				bulletTileXOffset = bulletTile[0]
				bulletTileYOffset = bulletTile[1]
			
			var bulletTileNode : Tile = getSpecificTile(bulletTilesOrigin.x + bulletTileXOffset, bulletTilesOrigin.y + bulletTileYOffset)
			if bulletTileNode != null:
				bulletTileNode.setTileAsBulletTile()
		
		if bulletTileRepetitions != 0:
			bulletTilesOrigin.x += bulletTileXOffset
			bulletTilesOrigin.y += bulletTileYOffset


func drawPlayerMoveTiles():
	getPlayerMoveTilesOrigin()
	
	for repetitions in range(playerMoveTileRepetitions + 1):
		var playerMoveTileXOffset
		var playerMoveTileYOffset
		
		for playerMoveTile in playerMoveTilesArray:
			if playerMoveTilesOriginOrientation == NORTH:
				playerMoveTileXOffset = playerMoveTile[1]
				playerMoveTileYOffset = playerMoveTile[0]
			elif playerMoveTilesOriginOrientation == EAST:
				playerMoveTileXOffset = playerMoveTile[0]
				playerMoveTileYOffset = playerMoveTile[1]
			elif playerMoveTilesOriginOrientation == SOUTH:
				playerMoveTileXOffset = playerMoveTile[1]
				playerMoveTileYOffset = playerMoveTile[0] * -1
			elif playerMoveTilesOriginOrientation == WEST:
				playerMoveTileXOffset = playerMoveTile[0] * -1
				playerMoveTileYOffset = playerMoveTile[1]
			
			if checkIfTileHasEnemy(playerMoveTilesOrigin.x + playerMoveTileXOffset, playerMoveTilesOrigin.y + playerMoveTileYOffset) == true:
				addTileToPlayerMoveTilesPath(playerMoveTilesOrigin.x + playerMoveTileXOffset, playerMoveTilesOrigin.y + playerMoveTileYOffset)
				break
			else:
				addTileToPlayerMoveTilesPath(playerMoveTilesOrigin.x + playerMoveTileXOffset, playerMoveTilesOrigin.y + playerMoveTileYOffset)
		
		if playerMoveTileRepetitions != 0:
			playerMoveTilesOrigin.x += playerMoveTileXOffset
			playerMoveTilesOrigin.y += playerMoveTileYOffset


func clearGunTiles():
	var columnsContainer = $ColumnsContainer
	for column in columnsContainer.get_children():
		for tile : Tile  in column.get_children():
			tile.setTileAsDefaultColor()
#endregion


#region MANAGE ORIGIN POSITIONS
func getBulletTilesOrigin():
	bulletTilesOrigin.x = playerPositionX
	bulletTilesOrigin.y = playerPositionY
	bulletTilesOrigin += bulletTilesOriginOrientation


func getPlayerMoveTilesOrigin():
	playerMoveTilesOrigin.x = playerPositionX
	playerMoveTilesOrigin.y = playerPositionY
	playerMoveTilesOrigin += playerMoveTilesOriginOrientation
#endregion


#region MANIPULATE TILE NODES
func addTileToPlayerMoveTilesPath(xPosition : int, yPosition : int):
	var tileToAdd = getSpecificTile(xPosition, yPosition)
	if tileToAdd != null:
		playerMoveTilesPath.append(tileToAdd)
		tileToAdd.setTileAsPlayerMoveTile()


func getSpecificTileAnchor(xPosition : int, yPosition : int) -> Marker2D:
	var tile = getSpecificTile(xPosition, yPosition)
	tile.setTileAsBulletTile()
	var tileAnchor = tile.get_child(0)
	
	return tileAnchor


func getSpecificTile(xPosition : int, yPosition : int) -> Tile:
	if mapWidthIndex >= xPosition && xPosition >= 0 && mapHeightIndex >= yPosition && yPosition >= 0:
		var columnsContainer = $ColumnsContainer
		var column = columnsContainer.get_child(xPosition)
		var tile : Tile = column.get_child(yPosition)
		
		return tile
	else:
		return null
#endregion


#region RECEIVE INPUT SIGNALS
# called from GlobalInput
func movePlayerUp():
	if playerPositionY - 1 < 0:
		pass
	else:
		playerPositionY -= 1
		var moveTargetTile = getSpecificTile(playerPositionX, playerPositionY)
		playerMoveTilesPath.append(moveTargetTile)
		playerMovementConfirmed = true


func movePlayerDown():
	if playerPositionY + 1 > mapHeightIndex:
		pass
	else:
		playerPositionY += 1
		var moveTargetTile = getSpecificTile(playerPositionX, playerPositionY)
		playerMoveTilesPath.append(moveTargetTile)
		playerMovementConfirmed = true


func movePlayerLeft():
	if playerPositionX - 1 < 0:
		pass
	else:
		playerPositionX -= 1
		var moveTargetTile = getSpecificTile(playerPositionX, playerPositionY)
		playerMoveTilesPath.append(moveTargetTile)
		playerMovementConfirmed = true


func movePlayerRight():
	if playerPositionX + 1 > mapWidthIndex:
		pass
	else:
		playerPositionX += 1
		var moveTargetTile = getSpecificTile(playerPositionX, playerPositionY)
		playerMoveTilesPath.append(moveTargetTile)
		playerMovementConfirmed = true


func rotateOriginLeft():
	if gunSelected == true:
		if bulletTilesOriginOrientation == NORTH:
			bulletTilesOriginOrientation = WEST
		elif bulletTilesOriginOrientation == WEST:
			bulletTilesOriginOrientation = SOUTH
		elif bulletTilesOriginOrientation == SOUTH:
			bulletTilesOriginOrientation = EAST
		elif bulletTilesOriginOrientation == EAST:
			bulletTilesOriginOrientation = NORTH
		
		if playerMoveTilesOriginOrientation == NORTH:
			playerMoveTilesOriginOrientation = WEST
		elif playerMoveTilesOriginOrientation == WEST:
			playerMoveTilesOriginOrientation = SOUTH
		elif playerMoveTilesOriginOrientation == SOUTH:
			playerMoveTilesOriginOrientation = EAST
		elif playerMoveTilesOriginOrientation == EAST:
			playerMoveTilesOriginOrientation = NORTH
		
		clearGunTiles()
		drawBulletTiles()
		drawPlayerMoveTiles()


func rotateOriginRight():
	if gunSelected == true:
		if bulletTilesOriginOrientation == NORTH:
			bulletTilesOriginOrientation = EAST
		elif bulletTilesOriginOrientation == EAST:
			bulletTilesOriginOrientation = SOUTH
		elif bulletTilesOriginOrientation == SOUTH:
			bulletTilesOriginOrientation = WEST
		elif bulletTilesOriginOrientation == WEST:
			bulletTilesOriginOrientation = NORTH
		
		if playerMoveTilesOriginOrientation == NORTH:
			playerMoveTilesOriginOrientation = EAST
		elif playerMoveTilesOriginOrientation == EAST:
			playerMoveTilesOriginOrientation = SOUTH
		elif playerMoveTilesOriginOrientation == SOUTH:
			playerMoveTilesOriginOrientation = WEST
		elif playerMoveTilesOriginOrientation == WEST:
			playerMoveTilesOriginOrientation = NORTH
		
		clearGunTiles()
		drawBulletTiles()
		drawPlayerMoveTiles()
#endregion


#region CONFIRM BUTTON SIGNAL
func movementConfirmed():
	gunSelected = false
	clearGunTiles()


func playerEnterAnimationFinished():
	GlobalSignal.playerInMotion.emit()
	playerMovementConfirmed = true
	playerStopAnimationPlayed = false
#endregion


#region GLOBAL SIGNALS
func _on_tree_entered() -> void:
	GlobalSignal.wKeyPressed.connect(movePlayerUp)
	GlobalSignal.aKeyPressed.connect(movePlayerLeft)
	GlobalSignal.sKeyPressed.connect(movePlayerDown)
	GlobalSignal.dKeyPressed.connect(movePlayerRight)
	GlobalSignal.qKeyPressed.connect(rotateOriginLeft)
	GlobalSignal.eKeyPressed.connect(rotateOriginRight)
	
	GlobalSignal.movementConfirmButtonPressed.connect(movementConfirmed)
	GlobalSignal.playerEnterAnimationEnded.connect(playerEnterAnimationFinished)
	
	GlobalSignal.gunSelected.connect(drawGunTilesPattern)
	GlobalSignal.gunUnselected.connect(clearGunTiles)
	
	GlobalSignal.spawnEnemyOnTile.connect(spawnEnemyOnTile)


func _on_tree_exited() -> void:
	GlobalSignal.wKeyPressed.disconnect(movePlayerUp)
	GlobalSignal.aKeyPressed.disconnect(movePlayerLeft)
	GlobalSignal.sKeyPressed.disconnect(movePlayerDown)
	GlobalSignal.dKeyPressed.disconnect(movePlayerRight)
	GlobalSignal.qKeyPressed.disconnect(rotateOriginLeft)
	GlobalSignal.eKeyPressed.disconnect(rotateOriginRight)
	
	GlobalSignal.movementConfirmButtonPressed.disconnect(movementConfirmed)
	GlobalSignal.playerEnterAnimationEnded.disconnect(playerEnterAnimationFinished)
	
	GlobalSignal.gunSelected.disconnect(drawGunTilesPattern)
	GlobalSignal.gunUnselected.disconnect(clearGunTiles)
	
	GlobalSignal.spawnEnemyOnTile.disconnect(spawnEnemyOnTile)
#endregion
