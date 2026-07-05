extends Node2D


#Removing a scene stays in memory but does not keep updating

enum CHOICE_TYPES {Reward, Punishment}

var round_num = 0
var total_round_num = 0

var requirements = {}
var filled_requirements = {}
var requirements_met = false
var round_time = GLOBALCONSTS.ROUND_TIME
var RNG = RandomNumberGenerator.new()
var allowed_sacrifices = ["carrot"]
var choice_type : CHOICE_TYPES = CHOICE_TYPES.Reward

var ANIMATED_ITEM = preload("res://scenes/animated_item.tscn")
var FLYING_COIN_SCENE = preload("res://scenes/flying_coin.tscn")
var CHECKMARK_IMG = load("res://art/ui/green_checkmark_outline.png")
var FORWARD_SLASH_IMG = load("res://art/ui/forward_slash.png")
var BOSS_SCENE = preload("res://scenes/boss/devil_boss.tscn")
var boss : Node2D

var mouse_on_mouth = false

#Tutorial
var first_sacrifice_made: bool = false
@export var TutorialManager: Node
@export var DialogManager: Node2D
@export var ItemManager: Node2D
@export var RoundNumber: Node2D


func _ready():
	if Cheats.ROUND_TIME_OVERRIDE:
		$Timer.wait_time = Cheats.ROUND_TIME_OVERRIDE
	else:
		$Timer.wait_time = round_time
	$Timer.start()
	start()
	
func set_boss(boss_, boss_position):
	boss = boss_.instantiate()
	boss.attempt_eat_item.connect(_attempt_eat_item)
	boss.position += boss_position # += since boss may already have an inteded offset
	add_child(boss)
	
func _process(_delta: float) -> void:
	update_timer_text()
	
func start():
	set_round_number(0)
	update_requirements()
	
func set_total_rounds(num: int) -> void:
	total_round_num = num
	
func set_round_number(num : int) -> void:
	round_num = num
	RoundNumber.set_round_number(round_num, total_round_num)
	
	
func update_round_number(num : int) -> void:
	round_num = num
	RoundNumber.update_round_number(round_num, total_round_num)
	
	
func open_godchoice_UI() -> void:
	if (requirements_met or Cheats.ALWAYS_REWARD) and not Cheats.ALWAYS_PUNISH:
		if round_num + 1 >= total_round_num:
			get_parent().get_parent().win_game()
		requirements_met = false
		choice_type = CHOICE_TYPES.Reward
		reward()
	else:
		choice_type = CHOICE_TYPES.Punishment
		punish()

func next_round() -> void:
	if choice_type == CHOICE_TYPES.Reward:
		update_round_number(round_num + 1)
	boss.set_hungry()
	$Timer.start()
	update_requirements()

func modify_round_time(change_time):
	set_round_time(round_time + change_time)
	if Cheats.ROUND_TIME_OVERRIDE:
		$Timer.wait_time = Cheats.ROUND_TIME_OVERRIDE
	else:
		$Timer.wait_time = round_time
	$Timer.start()
	
	
func set_round_time(time):
	round_time = time
	

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
func get_random_sacrifice_item():
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
	if num_groups > len(allowed_sacrifices):
		num_groups = len(allowed_sacrifices)
	
	requirements = {}
	filled_requirements = {}
	for i in range(num_groups):
		var item_name = get_random_sacrifice_item()
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
	
	
var sacrifice_text_image_positions : Dictionary= {}

#Updates the sacrifice text and images to match what they actualy are
func update_sacrifice_text():
	$SacrificeGUI/SacrificeText.text = ""
	for key in requirements:
		$SacrificeGUI/SacrificeText.add_image(load(GLOBALCONSTS.ITEM_DEF[key]["img_name"]+"_outline"+GLOBALCONSTS.IMG_EXTENSION))
		if filled_requirements[key] >= requirements[key]:
			$SacrificeGUI/SacrificeText.add_image(CHECKMARK_IMG)
			#var sacrifice_text_image_positions[key] = 
		else:
			$SacrificeGUI/SacrificeText.add_text(str(filled_requirements[key]))
			$SacrificeGUI/SacrificeText.add_image(FORWARD_SLASH_IMG)
			$SacrificeGUI/SacrificeText.add_text(str(requirements[key]))
			
		
		#func initialize(y, v,n : String,item_def : Dictionary ):
	#item_name = n
	#end_y = y
	#vel_factor = v
		
func give_coin_to_player():
	var temp = ANIMATED_ITEM.instantiate()
	ItemManager.add_child(temp)
	temp.position = $CoinSpawnLocation.position
	temp.initialize(temp.position.y + 30, Vector2(3,0), "gold", GLOBALCONSTS.ITEM_DEF["gold"])
	
	
	# Spawn flying coin at location in the sacrifice text
	#var temp = FLYING_COIN_SCENE.instantiate()
	#get_parent().add_child(temp)
	
# Returns number of items successfully saccrificed
func sacrifice(sacrificed_item_name, num_items:int = 1) -> int:
	var number_items_consumed = 0
	
	# If part of requirments and the requirment is not yet filled
	if sacrificed_item_name in requirements and filled_requirements[sacrificed_item_name] <= requirements[sacrificed_item_name]:
		var max_consume = requirements[sacrificed_item_name] - filled_requirements[sacrificed_item_name] # max number of items boss can consume
		print("The max number of %s I can consume is %d" % [sacrificed_item_name,max_consume])
		if num_items > max_consume:
			number_items_consumed = max_consume
		else:
			number_items_consumed = num_items
		
		boss.react_to(GLOBALCONSTS.ITEM_DEF[sacrificed_item_name]["reaction"], number_items_consumed)
		
		if filled_requirements[sacrificed_item_name] < requirements[sacrificed_item_name]:
			if not first_sacrifice_made:
				first_sacrifice_made = true
				TutorialManager.next(true, false, false)
			filled_requirements[sacrificed_item_name] += number_items_consumed
			if filled_requirements[sacrificed_item_name] >= requirements[sacrificed_item_name]: # Finished Requirment
				give_coin_to_player()
			update_sacrifice_text()
			check_requirements_met()
			if requirements_met:
				boss.set_full()
		else:
			DialogManager.override_current_dialog(GLOBALCONSTS.EXTRA_ITEM_FED_DIALOG)
	else:
		DialogManager.override_current_dialog(GLOBALCONSTS.EXTRA_ITEM_FED_DIALOG)
		
	return number_items_consumed

#Check if the all the requirments to please the boss have been met
func check_requirements_met():
	requirements_met = true
	for key in requirements:
		if filled_requirements[key] < requirements[key]:
			requirements_met = false
			
	
func _on_timer_timeout() -> void:
	open_godchoice_UI()
	
func reward():
	get_parent().reward()
func punish():
	get_parent().punish()
func _attempt_eat_item(on_mouth : bool):
	ItemManager.mouse_on_mouth = on_mouth
