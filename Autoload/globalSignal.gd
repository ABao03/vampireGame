extends Node

signal wKeyPressed
signal aKeyPressed
signal sKeyPressed
signal dKeyPressed
signal qKeyPressed
signal eKeyPressed

signal enableMovementInput # enables/disables movement when gun selected
signal disableMovementInput
signal movementConfirmButtonPressed

signal setPlayerPosition(position : Vector2)

signal playerEnterAnimationEnded()
signal playerInMotion()
signal playerStoppedMotion()

signal gunSelected(gunResource : GunResource)
signal gunUnselected(gunResource : GunResource)

signal turnEnded

signal spawnEnemyOnTile(tileXPosition : int, tileYPosition : int)
signal setEnemyPosition(position: Vector2)


# dummy emit
func _ready():
	if false:
		wKeyPressed.emit()
		aKeyPressed.emit()
		sKeyPressed.emit()
		dKeyPressed.emit()
		qKeyPressed.emit()
		eKeyPressed.emit()
		
		enableMovementInput.emit()
		disableMovementInput.emit()
		movementConfirmButtonPressed.emit()
		
		setPlayerPosition.emit(Vector2.ZERO)
		
		playerEnterAnimationEnded.emit()
		playerInMotion.emit()
		playerStoppedMotion.emit()
		
		gunSelected.emit(null)
		gunUnselected.emit(null)
		
		turnEnded.emit()
		
		spawnEnemyOnTile.emit(0, 0)
		setEnemyPosition.emit(Vector2.ZERO)
