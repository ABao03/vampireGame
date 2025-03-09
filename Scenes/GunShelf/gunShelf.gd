extends Control

var heldGunsIndexes : Array[int]

var gunsJsonPath = "res://Data/gunData.json"
var gunsJsonData : Dictionary

@onready var gunsContainer : VBoxContainer = $Background/GunsContainer


func _ready():
	heldGunsIndexes = [0,1]
	gunsJsonData = loadGunsJson()
	updateHeldGuns()


func updateHeldGuns():
	if heldGunsIndexes.size() > 4:
		print("too many held guns")
	else:
		for heldGunIndex in heldGunsIndexes:
			var gunData : Dictionary = gunsJsonData[str(heldGunIndex)]
			
			for gun : Gun in gunsContainer.get_children():
				gun.updateGun(gunData)


#region LOAD CARD DATA JSON
func loadGunsJson() -> Dictionary:
	var fileString = FileAccess.get_file_as_string(gunsJsonPath)
	var jsonData : Dictionary
	if fileString != null:
		jsonData = JSON.parse_string(fileString)
	
	return jsonData
#endregion
