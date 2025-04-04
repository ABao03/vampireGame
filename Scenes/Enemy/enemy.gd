class_name Enemy
extends Node2D

var thisEnemyResource: EnemyResource = EnemyResource.new()

var enemyAssetsPath = "res://Scenes/Enemy/Assets/"

var enemyTexture: Sprite2D


#region ENEMY POSITIONING
# called from TileMap
func setEnemyPosition(targetPositionVector: Vector2):
	global_position = targetPositionVector
#endregion


#region INITIALIZE ENEMY
func initializeEnemy(enemyData : Dictionary):
	thisEnemyResource.enemyName = enemyData["enemyName"]
	thisEnemyResource.enemyHP = enemyData["enemyHP"]
	thisEnemyResource.enemyAttackTiles = enemyData["enemyAttackTiles"]
	
	var enemyTexturePath = enemyAssetsPath + thisEnemyResource.enemyName.to_lower() + ".png"
	enemyTexture = $EnemyTexture
	enemyTexture.texture = load(enemyTexturePath)
	enemyTexture.position -= Vector2(0, enemyTexture.texture.get_height() * enemyTexture.scale.y / 5)
#endregion


#region GLOBAL SIGNAL
func _on_tree_entered() -> void:
	GlobalSignal.setEnemyPosition.connect(setEnemyPosition)


func _on_tree_exited() -> void:
	GlobalSignal.setEnemyPosition.disconnect(setEnemyPosition)
#endregion
