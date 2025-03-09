extends Node

@onready var inputCooldownTimer = $InputCooldownTimer

func _process(_delta: float) -> void:
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
