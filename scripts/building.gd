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
var STAGE_TO_HARVEST = 0
var STAGE_LOSS_ON_HARVEST = 0
var BOUNCE_WHEN_LAST_STAGE = false

var stage = 0#stages are zero indexed
var timer = 0
var num_items_inputed = 0

var ready_to_collect = false
var item_inputed = null


var delta_gift = 0

var arrow_pos_y = -10
var arrow_amplitude = 2
var arrow_freq = 0.5

#Harvest animation
var AMPLITUDE = 1
var PERIOD = 0.5
var ANIMATION_REST_TIME = 0.75

var animation_rest_timer = 0
var original_pos_y
var delta_total = 0

func initialize(def):
	#BUILDING_NAME = building_name
	BUILDING_DISPLAY_NAME = def["display_name"]
	OUTPUT_ITEMS = def["output_items"]
	ITEMS_TO_START_TIMER = def["items_to_start_timer"]
	INPUT_ITEMS = def["input_items"]
	TOTAL_STAGES = def["total_stages"]
	if Cheats.BUILDING_STAGE_TIME_OVERRIDE:
		TIME_PER_STAGE = Cheats.BUILDING_STAGE_TIME_OVERRIDE
	else:
		TIME_PER_STAGE = def["time_per_stage"]
	DESTROY_ON_HARVEST = def["destroy_on_harvest"]
	STAGE_TO_HARVEST = def["stage_to_harvest"]
	BOUNCE_WHEN_LAST_STAGE = def["bounce"]
	STAGE_LOSS_ON_HARVEST = def["stage_loss_on_harvest"]
	offset.x = def["offset"][0]
	offset.y = def["offset"][1]
	sprite_frames = load(def["frames"])
	update_stage()
	arrow_pos_y = -10
	original_pos_y = position.y

func bounce_animation(delta):
	if animation_rest_timer > ANIMATION_REST_TIME:
		delta_total += delta 
		var offset_y =  -AMPLITUDE * sin((delta_total)*2*PI/PERIOD)
		if offset_y <= 0:
			position.y = original_pos_y + offset_y
		else:
			position.y = original_pos_y
		if delta_total >= PERIOD/2.0:#we only care to go half a period
			animation_rest_timer = 0
			delta_total = 0
			position.y = original_pos_y
	else:
		animation_rest_timer += delta

#when click to empty
func _process(delta: float) -> void:
	if TIME_PER_STAGE != 0 and num_items_inputed>=ITEMS_TO_START_TIMER and stage < TOTAL_STAGES:
		timer += delta
	if timer > TIME_PER_STAGE:
		go_up_a_stage()
	if BOUNCE_WHEN_LAST_STAGE and stage >= TOTAL_STAGES:
		bounce_animation(delta)
	delta_gift += delta

	$Arrow.position.y = arrow_pos_y + 4 * sin(arrow_freq * 2 * PI * delta_gift)
	if BUILDING_DISPLAY_NAME == "Gift":
		rotation = PI/180* 20*sin(delta_gift*2)
	
func go_up_a_stage():#go up a stage
	stage +=1 
	timer = 0
	update_stage()
	
	
func update_stage():
	if sprite_frames.has_animation(str(stage)):
		play(str(stage))
	if stage >= STAGE_TO_HARVEST:
		ready_to_collect = true
	else:
		ready_to_collect = false
		
func place_item(item_name):
	if item_name in INPUT_ITEMS:
		if num_items_inputed < ITEMS_TO_START_TIMER:
			item_inputed = item_name
			num_items_inputed += 1
			go_up_a_stage()
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
			stage -= STAGE_LOSS_ON_HARVEST
			timer = 0
			num_items_inputed = 0
			update_stage()
			
		if item_inputed:
			return [INPUT_ITEMS[item_inputed]]
		else:
			return OUTPUT_ITEMS
	else:
		return []
func connectItemSignals(ItemManager):
	ItemManager.item_picked_up.connect(_item_picked_up)
	ItemManager.item_dropped.connect(_item_dropped)
#Recieve signal that says what item is being held/not held
func _item_picked_up(item_name):
	if item_name in INPUT_ITEMS and num_items_inputed < ITEMS_TO_START_TIMER:
		$Arrow.visible = true
	else:
		$Arrow.visible = false
func _item_dropped():
	$Arrow.visible = false





#put items in building
#take items from building
#both
#define action with building from stage
#when interacted with building goes to next stage
