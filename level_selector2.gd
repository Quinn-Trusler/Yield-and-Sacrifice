extends Node

@export var Level_Option : OptionButton
@export var Difficulty_Option : OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var difficulties = ["Baby","Easy", "Normal", "Hard", "Insane"]
var levels = ["grass", "sand", "swamp"]
func _on_play_pressed() -> void:
	$HBoxContainer.visible = false
	get_parent().generate_level(levels[Level_Option.selected], difficulties[Difficulty_Option.selected])

func show_level_selector():
	$HBoxContainer.visible = true
