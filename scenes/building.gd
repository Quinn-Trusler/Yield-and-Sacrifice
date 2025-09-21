extends AnimatedSprite2D

var BUILDING_TYPE = "building"
var IS_BUILDING = true


var RESOURCES = []
var STAGE_TO_START_TIMER = 0#put items in untill timer can start
var TOTAL_STAGES = 1
var STAGE_TIME = 10
var INPUT_ITEMS = []

var stage = 0#stages are zero indexed
var timer = 0

var ready_to_collect = false

#barel
#empty -> gets full then produces
#Fish net
#when click to empty
func _process(delta: float) -> void:
	if stage>=STAGE_TO_START_TIMER:
		timer += delta
	if timer >STAGE_TIME:
		up_stage()
	
func up_stage():#go up a stage
	stage +=1 
	timer = 0
	update_stage()
	
func update_stage():
	if stage >= TOTAL_STAGES-1:
		ready_to_collect = true
	frame = stage
func place_item(item_name):
	if item_name in INPUT_ITEMS:
		if stage < STAGE_TO_START_TIMER:
			#stage +=1
			#update_stage()
			up_stage()
			return true
		else:
			return false
	else:
		return false
	

func harvest():
	if ready_to_collect:
		return RESOURCES
	else:
		return false


#put items in building
#take items from building
#both
#define action with building from stage
#when interacted with building goes to next stage
