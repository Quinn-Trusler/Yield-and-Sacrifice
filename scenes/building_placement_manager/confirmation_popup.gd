extends Node2D

signal confirm
signal cancel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_confirm_pressed() -> void:
	print("confirm")
	confirm.emit()


func _on_cancel_pressed() -> void:
	print("cancel")
	cancel.emit()
