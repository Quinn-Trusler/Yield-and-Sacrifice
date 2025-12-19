extends Node2D


#Removing a scene stays in memory but does not keep updating


var round_num = 0

var requirements = {}
var filled_requirements = {}
var requirements_met = false
var round_time = 20
var RNG = RandomNumberGenerator.new()
var allowed_sacrafices = ["carrot"]

func _ready():
	$Timer.wait_time = round_time
	start()
func _process(_delta: float) -> void:
	update_timer_text()
	
func start():
	round_num = 0
	update_requirements()
func next_round():
	round_num +=1
	if requirements_met:
		requirements_met = false
		reward()
	else:
		punish()
	

var TIMEDECIMALTHRESHOLD = 5
var TIMEDECIMALS = 10
func update_timer_text():
	if $Timer.time_left <= TIMEDECIMALTHRESHOLD:
		$TimerGUI/TimeText.text = str(round($Timer.time_left*TIMEDECIMALS)/TIMEDECIMALS)
	else:
		$TimerGUI/TimeText.text = str(int(round($Timer.time_left)))
		
func add_allowed_sacrafice(item_name):
	if not(item_name in allowed_sacrafices):
		allowed_sacrafices.append(item_name)
	

func get_round_requirements():
	#determine items total 
	#detrmine ask for 1,2 or 3 items
	var items_total = round_num + 1
	var item_groups = 3
	if items_total <= 2:
		item_groups = 1
	elif items_total <= 5:
		item_groups = 2
	
	print(allowed_sacrafices)
	var temp_requirements = {}
	for i in range(item_groups):
		var num = RNG.randi_range(0,len(allowed_sacrafices)-1)
		var num_items = round(items_total/(item_groups-i))
		items_total -= num_items
		temp_requirements[allowed_sacrafices[num]] = num_items
	return temp_requirements
	#if round_num <= -1:
		#return {"carrot":2}
	#elif round_num <=5:
		#var num_potatoes = RNG.randi_range(2,3)
		#return {"potatoe":num_potatoes,"carrot":5-num_potatoes}
	#return {"carrot":999}
		
#update the sacrafice requirments to the new ones based on round
func update_requirements():
	requirements = get_round_requirements()
	
	#setup filled_requirements
	filled_requirements = {}
	for key in requirements:
		filled_requirements[key] = 0
	update_sacrafice_text()
	
#Updates the sacrafice text and images to match what they actualy are
func update_sacrafice_text():
	$SacraficeGUI/SacraficeText.text = ""
	for key in requirements:
		$SacraficeGUI/SacraficeText.add_image(load(GLOBALCONSTS.ITEM_DEF[key]["img_name"]+"_outline"+GLOBALCONSTS.IMG_EXTENSION))
		$SacraficeGUI/SacraficeText.add_text(str(filled_requirements[key]))
		$SacraficeGUI/SacraficeText.add_image(load("res://art/ui/forward_slash.png"))
		$SacraficeGUI/SacraficeText.add_text(str(requirements[key]))
		
func sacrafice(sacraficed_item_name):
	if sacraficed_item_name in requirements:
		if filled_requirements[sacraficed_item_name] < requirements[sacraficed_item_name]:
			filled_requirements[sacraficed_item_name] +=1 
			update_sacrafice_text()
			check_requirements_met()
		else:
			print("wasted sacrafice")
	else:
		print("wasted sacrafice")

#Check if the all the requirments to please the boss have been met
func check_requirements_met():
	requirements_met = true
	for key in requirements:
		if filled_requirements[key] < requirements[key]:
			requirements_met = false
			
	
func _on_timer_timeout() -> void:
	next_round()
	$Timer.start()
func reward():
	get_parent().reward()
func punish():
	get_parent().punish()
