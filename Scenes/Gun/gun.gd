class_name Gun
extends Control

# nodes
var gunTexture
var gunTexturePosition: Vector2 = Vector2(0,0)
var gunTextureSelectedPosition: Vector2 = Vector2(100,0)

var gunAssetsPath = "res://Scenes/Gun/Assets/"

var thisGunResource : GunResource = GunResource.new()

var gunSelected : bool = false

#region INITIALIZE GUN
func updateGun(gunData : Dictionary):
	thisGunResource.gunName = gunData["gunName"]
	thisGunResource.gunClip = gunData["gunClip"]
	thisGunResource.bulletTiles = gunData["bulletTiles"]
	thisGunResource.bulletTilesRepetitions = gunData["bulletTilesRepetitions"]
	thisGunResource.playerMoveTiles = gunData["playerMoveTiles"]
	thisGunResource.playerMoveTilesRepetitions = gunData["playerMoveTilesRepetitions"]
	thisGunResource.gunDescription = gunData["gunDescription"]
	
	var gunTexturePath = gunAssetsPath + thisGunResource.gunName.to_lower() + ".png"
	gunTexture = $GunTexture
	gunTexture.texture = load(gunTexturePath)
#endregion


#region RESET GUN
func resetGun():
	gunSelected = false
	if gunTexture != null:
		gunTexture.position = gunTexturePosition
#endregion


#region BUTTON CONTROLS
func _on_button_mouse_entered() -> void:
	gunTexture = $GunTexture
	if gunSelected == false:
		gunTexture.position = gunTextureSelectedPosition


func _on_button_mouse_exited() -> void:
	gunTexture = $GunTexture
	if gunSelected == false:
		gunTexture.position = gunTexturePosition


func _on_button_pressed() -> void:
	if gunSelected == false:
		gunSelected = true
		GlobalSignal.gunSelected.emit(thisGunResource)
		GlobalSignal.disableMovementInput.emit()
	else:
		gunSelected = false
		GlobalSignal.gunUnselected.emit()
		GlobalSignal.enableMovementInput.emit()
#endregion
