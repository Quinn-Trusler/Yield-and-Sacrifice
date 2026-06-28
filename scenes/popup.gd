extends Node2D


@onready var level_name = $VBoxContainer/LevelName
@onready var level_number = $VBoxContainer/LevelNumber
@onready var difficulty_display = $DifficultyHBox/DifficultyDisplay
@onready var round_time = $VBoxContainer/BulletInfo/RoundTime

var level_num = 0
var difficulty = 0

var pepper_img = load("res://art/ui/difficulty_pepper_scale.png")

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
	difficulty_display.add_text(GLOBALCONSTS.DIFFICULTY_NAMES[difficulty] + " ")
	for i in range(difficulty +1):
		difficulty_display.add_image(pepper_img)
	round_time.text = "Round Time: " + str(GLOBALCONSTS.DIFFICULTY_TIMES[difficulty]) + "s" 
	

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
	difficulty -= 1
	if difficulty < 0:
		difficulty = len(GLOBALCONSTS.DIFFICULTY_NAMES) -1
	update_difficulty_display()

func _on_close_pressed() -> void:
	close()

func _on_play_pressed() -> void:
	play()
	

	
	
