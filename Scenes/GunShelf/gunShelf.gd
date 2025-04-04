extends Control

var heldGunsIndexes : Array[int]

var gunsJsonPath = "res://Data/gunData.json"
var gunsJsonData : Dictionary

@onready var gunsContainer : VBoxContainer = $Background/GunsContainer

#region INITIALIZE GUNS
func _ready():
	heldGunsIndexes = [0,1]
	gunsJsonData = loadGunsJson()
	updateHeldGuns()


func updateHeldGuns():
	if heldGunsIndexes.size() > 4:
		print("too many held guns")
	else:
		var currentGunChildIndex = 0
		
		for heldGunIndex in heldGunsIndexes:
			var gunData : Dictionary = gunsJsonData[str(heldGunIndex)]
			
			var gun : Gun = gunsContainer.get_child(currentGunChildIndex)
			gun.updateGun(gunData)
			
			currentGunChildIndex += 1
#endregion


#region RESET GUNS
func resetGuns():
	for gun : Gun in gunsContainer.get_children():
		gun.resetGun()
#endregion


#region LOAD CARD DATA JSON
func loadGunsJson() -> Dictionary:
	var fileString = FileAccess.get_file_as_string(gunsJsonPath)
	var jsonData : Dictionary
	if fileString != null:
		jsonData = JSON.parse_string(fileString)
	
	return jsonData
#endregion


#region BUTTONS PRESSED
# send signal to TileMap
func _on_confirm_button_pressed() -> void:
	GlobalSignal.movementConfirmButtonPressed.emit()
	resetGuns()
#endregion


#region GLOBAL SIGNAL
func _on_tree_entered() -> void:
	pass


func _on_tree_exited() -> void:
	pass
#endregion
