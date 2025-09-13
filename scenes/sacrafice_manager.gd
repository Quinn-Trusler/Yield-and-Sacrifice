extends Node2D


var round = 0

var requirements = {}
var filled_requirements = {}
var requirements_met = false

func _ready():
	start()

func start():
	round = 0
	update_requirements()
func next_round():
	round +=1
	if requirements_met:
		requirements_met = false
		reward()
	else:
		punish()
	update_requirements()
	
func update_requirements():
	requirements = {"carrot":2}
	
	#setup filled_requirements
	filled_requirements = {}
	for key in requirements:
		filled_requirements[key] = 0
	update_sacrafice_text()
	
func update_sacrafice_text():
	$SacraficeText.text = ""
	for key in requirements:
		$SacraficeText.add_image(load("res://art/items/carrot.png"))
		$SacraficeText.add_text(str(filled_requirements[key]) +"/"+ str(requirements[key]))
	print("sacrafice text updated")
		
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
		if filled_requirements[key] >= requirements[key]:
			requirements_met = false
			
	
func _on_timer_timeout() -> void:
	next_round()
	$Timer.start()
func reward():
	print("reward TBI")
func punish():
	print("punish TBI")
