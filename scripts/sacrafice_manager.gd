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
	

func get_round_requirements():
	#determine items total 
	#detrmine ask for 1,2 or 3 items
	var items_total = round_num + 1
	var item_groups = 3
	if items_total <= 2:
		item_groups = 1
	elif items_total <= 5:
		item_groups = 2
	
	var temp_requirements = {}
	for i in range(item_groups):
		var num = RNG.randi_range(0,len(allowed_sacrifices)-1)
		var num_items = round(items_total/(item_groups-i))
		items_total -= num_items
		temp_requirements[allowed_sacrifices[num]] = num_items
	return temp_requirements
		
#update the sacrifice requirments to the new ones based on round
func update_requirements():
	requirements = get_round_requirements()
	
	#setup filled_requirements
	filled_requirements = {}
	for key in requirements:
		filled_requirements[key] = 0
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
