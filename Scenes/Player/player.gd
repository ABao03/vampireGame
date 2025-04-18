class_name Player
extends Node2D

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var speed = 10

var playerFacingRight = true

#region PLAYER MOVEMENT
# called from TileMap
func setPlayerPosition(targetPositionVector: Vector2):
	global_position = targetPositionVector - $PlayerAnchor.position


func movePlayerTowardsPosition(targetPositionVector: Vector2):
	if animation.current_animation == "dash":
		var directionVector = (targetPositionVector - sprite.global_position).normalized()
		playerFacingRight = directionVector.x >= 0
	
	var positionDifference = targetPositionVector - $PlayerAnchor.global_position
	
	var movement = positionDifference * 1/speed
	global_position += movement
#endregion


#region ANIMATION CONTROL
func _ready() -> void:
	animation.play("idle")


func gunSelectedPreparePlayer(_gunResource : GunResource):
	animation.play("prepare")


func gunUnselectedIdlePlayer():
	animation.play("idle")


func confirmPressedEnterPlayer():
	animation.play("enter")


func playerInMotion():
	animation.play("dash")


func playerStopped():
	animation.play("exit")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "enter":
		GlobalSignal.playerEnterAnimationEnded.emit()
	if anim_name == "exit":
		animation.play("idle")


func setPlayerFacing(moveTargetAnchor : Marker2D):
	var directionVector = (moveTargetAnchor.global_position - sprite.global_position).normalized()
	if directionVector.x >= 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
#endregion


#region GET ANCHOR
func getAnchor():
	return $PlayerAnchor
#endregion


#region GLOBAL SIGNALS
func _on_tree_entered() -> void:
	GlobalSignal.setPlayerPosition.connect(setPlayerPosition)
	
	GlobalSignal.gunSelected.connect(gunSelectedPreparePlayer)
	GlobalSignal.gunUnselected.connect(gunUnselectedIdlePlayer)
	GlobalSignal.movementConfirmButtonPressed.connect(confirmPressedEnterPlayer)
	
	GlobalSignal.playerInMotion.connect(playerInMotion)
	GlobalSignal.playerStoppedMotion.connect(playerStopped)


func _on_tree_exited() -> void:
	GlobalSignal.setPlayerPosition.disconnect(setPlayerPosition)
	
	GlobalSignal.gunSelected.disconnect(gunSelectedPreparePlayer)
	GlobalSignal.gunUnselected.disconnect(gunUnselectedIdlePlayer)
	GlobalSignal.movementConfirmButtonPressed.disconnect(confirmPressedEnterPlayer)
	
	GlobalSignal.playerInMotion.disconnect(playerInMotion)
	GlobalSignal.playerStoppedMotion.disconnect(playerStopped)
#endregion
