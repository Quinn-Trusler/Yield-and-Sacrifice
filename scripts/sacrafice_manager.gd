extends Node2D


#Removing a scene stays in memory but does not keep updating


var round_num = 0

var requirements = {}
var filled_requirements = {}
var requirements_met = false
var round_time = 20
var RNG = RandomNumberGenerator.new()
var allowed_sacrifices = ["carrot"]

var CHECKMARK_IMG = load("res://art/ui/green_checkmark_outline.png")
var FORWARD_SLASH_IMG = load("res://art/ui/forward_slash.png")
var DEVIL_BOSS_SCENE = preload("res://scenes/devil_boss.tscn")
var devil_boss : Node2D

var mouse_on_mouth = false

#Tutorial
var first_sacrifice_made: bool = false
@export var TutorialManager: Node
@export var DialogManager: CanvasLayer
@export var ItemManager: Node2D

func _ready():
	devil_boss = DEVIL_BOSS_SCENE.instantiate()
	add_child(devil_boss)
	devil_boss.attempt_eat_item.connect(_attempt_eat_item)
	if Cheats.ROUND_TIME_OVERRIDE:
		$Timer.wait_time = Cheats.ROUND_TIME_OVERRIDE
	else:
		$Timer.wait_time = round_time
	$Timer.start()
	start()
func _process(_delta: float) -> void:
	update_timer_text()
	
func start():
	round_num = 0
	update_requirements()
func next_round():
	round_num +=1
	if (requirements_met or Cheats.ALWAYS_REWARD) and not Cheats.ALWAYS_PUNISH:
		requirements_met = false
		reward()
	else:
		punish()

func modify_round_time(change_time):
	round_time += change_time
	if Cheats.ROUND_TIME_OVERRIDE:
		$Timer.wait_time = Cheats.ROUND_TIME_OVERRIDE
	else:
		$Timer.wait_time = round_time
	$Timer.start()

var TIMEDECIMALTHRESHOLD = 5
var TIMEDECIMALS = 10
func update_timer_text():
	if $Timer.time_left <= TIMEDECIMALTHRESHOLD:
		$TimerGUI/TimeText.text = str(round($Timer.time_left*TIMEDECIMALS)/TIMEDECIMALS)
	else:
		$TimerGUI/TimeText.text = str(int(round($Timer.time_left)))
		
func add_allowed_sacrifice(item_name):
	if not(item_name in allowed_sacrifices):
		allowed_sacrifices.append(item_name)
	
# Will get item not already in requirments list
func get_random_sacrafice_item():
	while true:
		var num = RNG.randi_range(0,len(allowed_sacrifices)-1)
		var item_name = allowed_sacrifices[num]
		if !(item_name in requirements):
			return item_name

func set_new_requirements():
	var points_remaining = (round_num + 1) * 10
	var num_groups = 3
	if round_num <= 1:
		num_groups = 1
	elif round_num <= 4:
		num_groups = 2
	
	requirements = {}
	filled_requirements = {}
	for i in range(num_groups):
		var item_name = get_random_sacrafice_item()
		var points = points_remaining/(num_groups-i)
		var num_items = floor(points/GLOBALCONSTS.ITEM_DEF[item_name]["points"])
		if num_items < 1:
			num_items = 1
		points_remaining -= num_items * GLOBALCONSTS.ITEM_DEF[item_name]["points"]
		
		requirements[item_name] = num_items
		filled_requirements[item_name] = 0
		
#update the sacrifice requirments to the new ones based on round
func update_requirements():
	set_new_requirements()
	update_sacrifice_text()
	
#Updates the sacrifice text and images to match what they actualy are
func update_sacrifice_text():
	$SacrificeGUI/SacrificeText.text = ""
	for key in requirements:
		$SacrificeGUI/SacrificeText.add_image(load(GLOBALCONSTS.ITEM_DEF[key]["img_name"]+"_outline"+GLOBALCONSTS.IMG_EXTENSION))
		if filled_requirements[key] >= requirements[key]:
			$SacrificeGUI/SacrificeText.add_image(CHECKMARK_IMG)
		else:
			$SacrificeGUI/SacrificeText.add_text(str(filled_requirements[key]))
			$SacrificeGUI/SacrificeText.add_image(FORWARD_SLASH_IMG)
			$SacrificeGUI/SacrificeText.add_text(str(requirements[key]))
		
func sacrifice(sacrificed_item_name):
	if sacrificed_item_name in requirements:
		if filled_requirements[sacrificed_item_name] < requirements[sacrificed_item_name]:
			if not first_sacrifice_made:
				first_sacrifice_made = true
				TutorialManager.next(true, false, false)
			filled_requirements[sacrificed_item_name] +=1 
			update_sacrifice_text()
			check_requirements_met()
			if requirements_met:
				devil_boss.set_full()
		else:
			DialogManager.override_current_dialog(GLOBALCONSTS.EXTRA_ITEM_FED_DIALOG)
	else:
		DialogManager.override_current_dialog(GLOBALCONSTS.EXTRA_ITEM_FED_DIALOG)

#Check if the all the requirments to please the boss have been met
func check_requirements_met():
	requirements_met = true
	for key in requirements:
		if filled_requirements[key] < requirements[key]:
			requirements_met = false
			
	
func _on_timer_timeout() -> void:
	next_round()
	devil_boss.set_full()
	$Timer.start()
func reward():
	get_parent().reward()
func punish():
	get_parent().punish()
func _attempt_eat_item(on_mouth : bool):
	ItemManager.mouse_on_mouth = on_mouth
