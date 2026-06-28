extends Node2D


@onready var level_name = $VBoxContainer/LevelName
@onready var level_number = $VBoxContainer/LevelNumber
@onready var difficulty_display = $DifficultyDisplay

var level_num = 0
var difficulty = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func _on_close_button_pressed() -> void:
	close()


func open(n : int):
	visible = true
	level_num = n
	difficulty = GLOBALCONSTS.DEFAULT_DIFFICULTY
	level_number.text = "Level " + str(n)
	level_name.text = GLOBALCONSTS.LEVEL_DISPlAY_NAMES[level_num - 1]
	
	update_difficulty_display()

func update_difficulty_display():
	difficulty_display.clear()
	difficulty_display.add_text(GLOBALCONSTS.DIFFICULTY_NAMES[difficulty])

func play():
	close()
	get_parent().play_level(level_num, difficulty)
	#difficulty
	#level_num
	
func close():
	visible = false


func _on_up_pressed() -> void:
	difficulty = (difficulty + 1) % len(GLOBALCONSTS.DIFFICULTY_NAMES)
	update_difficulty_display()

func _on_down_pressed() -> void:
	difficulty = (difficulty - 1) % len(GLOBALCONSTS.DIFFICULTY_NAMES)
	update_difficulty_display()

func _on_close_pressed() -> void:
	close()

func _on_play_pressed() -> void:
	play()
	

	
	
