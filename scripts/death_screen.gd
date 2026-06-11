extends CanvasLayer

#@onready var menu_file_name = "res://scenes/level_selector.tscn"
#@onready var main_scene = "res://scenes/main.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#func _on_play_again_pressed() -> void:
	#get_tree().paused = false
	#get_tree().change_scene_to_file(main_scene)


func _on_back_to_menu_pressed() -> void:
	get_tree().paused = false
	visible = false
