extends Node2D

@onready var main_file_name = "res://scenes/main.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_play_game_button_pressed() -> void:
	get_tree().change_scene_to_file(main_file_name)
