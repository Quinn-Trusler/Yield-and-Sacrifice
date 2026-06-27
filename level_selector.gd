extends Node2D

@onready var main_file_name = "res://scenes/main.tscn"
@export var scene_manager : Node

var difficulties = ["Baby","Easy", "Normal", "Hard", "Insane"]
var levels = ["grass", "sand", "swamp"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LevelButton1.set_locked(false)
	$LevelButton2.set_locked(false)
	$LevelButton3.set_locked(false)
	
	
func play_level(level_number : int, difficulty :String):
	visible = false
	scene_manager.generate_level(levels[level_number - 1], difficulty)

func open_popup(level_number):
	#$Popup.open(level_number)
	play_level(level_number, "Normal")
	
func close_popup():
	$Popup.close()
	
func show_level_selector():
	visible = true
