extends Node2D


#Removing a scene stays in memory but does not keep updating


var round_num = 0

var requirements = {}
var filled_requirements = {}
var requirements_met = false
var round_time = 20
var ITEM_DEF = null

func _ready():
	ITEM_DEF = get_parent().ITEM_DEF
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
	update_requirements()

func update_timer_text():
	$TimeText.text = str(ceil($Timer.time_left))
func get_round_requirements():
	if round_num <= -1:
		return {"carrot":2}
	elif round_num <=5:
		return {"potatoe":2,"carrot":3}
func update_requirements():#update for new round
	requirements = get_round_requirements()
	print("round num",round_num)
	
	#setup filled_requirements
	filled_requirements = {}
	for key in requirements:
		filled_requirements[key] = 0
	update_sacrafice_text()
	
func update_sacrafice_text():#whenever the numbers change
	$SacraficeText.text = ""
	for key in requirements:
		$SacraficeText.add_image(load(ITEM_DEF[key]["img_name"]))
		$SacraficeText.add_text(str(filled_requirements[key]) +"/"+ str(requirements[key]))
		
func sacrafice(sacrafice_name):
	if sacrafice_name in requirements:
		if filled_requirements[sacrafice_name] < requirements[sacrafice_name]:
			filled_requirements[sacrafice_name] +=1 
			update_sacrafice_text()
			check_requirements_met()
		else:
			print("wasted sacrafice")
	else:
		print("wasted sacrafice")

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
