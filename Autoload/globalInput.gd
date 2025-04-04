extends Node

@onready var inputCooldownTimer: Timer  = $InputCooldownTimer
var movementInputPaused : bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("q_rotate_left"):
		GlobalSignal.qKeyPressed.emit()
		inputCooldownTimer.start()
	
	if Input.is_action_just_pressed("e_rotate_right"):
		GlobalSignal.eKeyPressed.emit()
		inputCooldownTimer.start()
	
	if movementInputPaused == false:
		if Input.is_action_just_pressed("w_up"):
			if inputCooldownTimer.is_stopped() == true:
				GlobalSignal.wKeyPressed.emit()
				inputCooldownTimer.start()
				
		if Input.is_action_just_pressed("s_down"):
			if inputCooldownTimer.is_stopped() == true:
				GlobalSignal.sKeyPressed.emit()
				inputCooldownTimer.start()
				
		if Input.is_action_just_pressed("a_left"):
			if inputCooldownTimer.is_stopped() == true:
				GlobalSignal.aKeyPressed.emit()
				inputCooldownTimer.start()
				
		if Input.is_action_just_pressed("d_right"):
			if inputCooldownTimer.is_stopped() == true:
				GlobalSignal.dKeyPressed.emit()
				inputCooldownTimer.start()


#region INPUT CONTROL
func toggleMovementInput():
	if movementInputPaused == false:
		movementInputPaused = true
	else:
		movementInputPaused = false
#endregion


#region GLOBAL SIGNALS
func _on_tree_entered() -> void:
	GlobalSignal.toggleMovementInput.connect(toggleMovementInput)


func _on_tree_exited() -> void:
	GlobalSignal.toggleMovementInput.disconnect(toggleMovementInput)
#endregion
