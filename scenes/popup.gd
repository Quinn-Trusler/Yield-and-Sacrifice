extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


func _on_close_button_pressed() -> void:
	close()


func open(level_number : int):
	visible = true
	
func close():
	visible = false
