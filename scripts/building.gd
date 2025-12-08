extends AnimatedSprite2D

var BUILDING_TYPE = "building"
var IS_BUILDING = true

var BUILDING_NAME = "none"
var BUILDING_DISPLAY_NAME = "none"

var OUTPUT_ITEMS = []
var ITEMS_TO_START_TIMER = 0#put items in untill timer can start
var INPUT_ITEMS = []

var TOTAL_STAGES = 1
var TIME_PER_STAGE = 10

var DESTROY_ON_HARVEST = false
var STAGE_LOSS_ON_HARVEST = 0

var stage = 0#stages are zero indexed
var timer = 0
var num_items_inputed = 0

var ready_to_collect = false

func initialize(def):
	#BUILDING_NAME = building_name
	BUILDING_DISPLAY_NAME = def["display_name"]
	OUTPUT_ITEMS = def["output_items"]
	ITEMS_TO_START_TIMER = def["items_to_start_timer"]
	INPUT_ITEMS = def["input_items"]
	TOTAL_STAGES = def["total_stages"]
	TIME_PER_STAGE = def["time_per_stage"]
	DESTROY_ON_HARVEST = def["destroy_on_harvest"]
	STAGE_LOSS_ON_HARVEST = def["stage_loss_on_harvest"]
	offset.x = def["offset"][0]
	offset.y = def["offset"][1]
	sprite_frames = load(def["frames"])
	update_stage()
#barel
#empty -> gets full then produces
#Fish net
#when click to empty
func _process(delta: float) -> void:
	if TIME_PER_STAGE != 0 and num_items_inputed>=ITEMS_TO_START_TIMER:
		timer += delta
	if timer > TIME_PER_STAGE:
		go_up_a_stage()
	
func go_up_a_stage():#go up a stage
	stage +=1 
	timer = 0
	update_stage()
	
	
func update_stage():
	if sprite_frames.has_animation(str(stage)):
		play(str(stage))
	if stage >= TOTAL_STAGES-1:
		ready_to_collect = true
	else:
		ready_to_collect = false
		
func place_item(item_name):
	if item_name in INPUT_ITEMS:
		if num_items_inputed < ITEMS_TO_START_TIMER:
			num_items_inputed += 1
			return true
		else:
			return false
	else:
		return false
	
func get_harvestable():
	return ready_to_collect

func harvest():
	if ready_to_collect:
		if STAGE_LOSS_ON_HARVEST:
			print("setback by", STAGE_LOSS_ON_HARVEST)
			stage -= STAGE_LOSS_ON_HARVEST
			timer = 0
			num_items_inputed = 0
			update_stage()
		return OUTPUT_ITEMS
	else:
		return []


#put items in building
#take items from building
#both
#define action with building from stage
#when interacted with building goes to next stage
