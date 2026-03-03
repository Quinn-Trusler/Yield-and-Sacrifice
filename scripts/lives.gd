extends Node2D

var life_scenes = []
var LIFE_ON = "life on"
var LIFE_OFF = "life off"
var MAX_LIVES = GLOBALCONSTS.MAX_LIVES
var LIFE_SPACING = 15
var lives_left = MAX_LIVES
@onready var life_scene = load("res://scenes/life.tscn")
@onready var DeathScreen = get_node("/root/Main/DeathScreen")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(MAX_LIVES):
		var temp = life_scene.instantiate()
		temp.position.x = i*LIFE_SPACING
		life_scenes.append(temp)
		add_child(temp)
		
	set_lives()


func gain_life():
	lives_left +=1
	set_lives()
func lose_life():
	lives_left -= 1
	if lives_left <= 0:
		game_over()
	set_lives()
func game_over():
	#go back to menu or something
	DeathScreen.visible = true
	get_tree().paused = true
	
func set_max_lives():
	lives_left = MAX_LIVES
	set_lives()
func is_at_max():
	return (lives_left == MAX_LIVES)

func set_lives():
	#lower indexs are further left and the first to turn off
	for i in range(len(life_scenes)):
		if i >= (lives_left):
			life_scenes[i].play(LIFE_OFF)
		else:
			life_scenes[i].play(LIFE_ON)
		
