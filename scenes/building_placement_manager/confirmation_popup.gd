extends Node2D

signal confirm
signal cancel
signal updateHoverStatus(status : bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_confirm_pressed() -> void:
	confirm.emit()

func _on_cancel_pressed() -> void:
	cancel.emit()

func _on_hover_detector_mouse_entered() -> void:
	updateHoverStatus.emit(true)

func _on_hover_detector_mouse_exited() -> void:
	updateHoverStatus.emit(false)
