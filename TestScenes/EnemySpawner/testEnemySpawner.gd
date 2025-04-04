class_name testEnemySpawner
extends Node2D

var enemyJsonPath = "res://Data/enemyData.json"
var enemyJsonData : Dictionary

var currentEnemyIndexToSpawn: int = 0
var tileToSpawnEnemiesArray: Array[Vector2] = [
	Vector2(4,2)
]

#region INITIALIZE ENEMY DATA
func _ready():
	enemyJsonData = loadEnemyJson()
	call_deferred("spawnEnemy")
#endregion


#region SPAWN ENEMY
func spawnEnemy():
	var enemyData: Dictionary = enemyJsonData[str(currentEnemyIndexToSpawn)]
	var enemyScene = load("res://Scenes/Enemy/enemy.tscn")
	var enemyInstance: Enemy = enemyScene.instantiate()
	enemyInstance.initializeEnemy(enemyData)
	add_child(enemyInstance)
	
	var enemySpawnTilePosition: Vector2 = getSetEnemySpawnPosition()
	GlobalSignal.spawnEnemyOnTile.emit(enemySpawnTilePosition.x, enemySpawnTilePosition.y)
	tileToSpawnEnemiesArray.remove_at(0)


func getSetEnemySpawnPosition() -> Vector2:
	var spawnPosition: Vector2 = tileToSpawnEnemiesArray[0]
	return spawnPosition
#endregion


#region LOAD ENEMY DATA JSON
func loadEnemyJson() -> Dictionary:
	var fileString = FileAccess.get_file_as_string(enemyJsonPath)
	var jsonData : Dictionary
	if fileString != null:
		jsonData = JSON.parse_string(fileString)
	
	return jsonData
#endregion
