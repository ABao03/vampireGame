class_name Player
extends Node2D


#region PLAYER MOVEMENT
# called from TileMap
func updatePlayerPosition(positionVector : Vector2):
	global_position = positionVector
#endregion


#region GLOBAL SIGNALS
func _on_tree_entered() -> void:
	GlobalSignal.updatePlayerPosition.connect(updatePlayerPosition)


func _on_tree_exited() -> void:
	GlobalSignal.updatePlayerPosition.disconnect(updatePlayerPosition)
#endregion
