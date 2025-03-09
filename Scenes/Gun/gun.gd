class_name Gun
extends Control

# nodes
var gunTexture

var gunAssetsPath = "res://Scenes/Gun/Assets/"

var thisGunResource : GunResource = GunResource.new()


func updateGun(gunData : Dictionary):
	thisGunResource.gunName = gunData["gunName"]
	thisGunResource.gunClip = gunData["gunClip"]
	thisGunResource.gunTiles = gunData["gunTiles"]
	thisGunResource.gunDescription = gunData["gunDescription"]
	
	var gunTexturePath = gunAssetsPath + thisGunResource.gunName.to_lower() + ".png"
	gunTexture = $GunTexture
	gunTexture.texture = load(gunTexturePath)


#region BUTTON CONTROLS
func _on_button_mouse_entered() -> void:
	gunTexture = $GunTexture
	gunTexture.position.x += 100


func _on_button_mouse_exited() -> void:
	gunTexture = $GunTexture
	gunTexture.position.x -= 100


func _on_button_pressed() -> void:
	pass # Replace with function body.
#endregion
