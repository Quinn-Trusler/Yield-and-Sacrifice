extends AnimatedSprite2D

#don't touch this
var BUILDING_TYPE = "crop"
var IS_BUILDING = false

#differ by plant
var stage_growth_duration = 2
var total_stages = 4

var harvest_on_click = true
var pick_on_click = 0 #number of picks allowed
var pick_stage_setback = 0 #how far crop is setback when picked
var resources = []#ex ["carrot","carrot"] for 2 carrots

#change as plant grows
var stage = 0
var timer = 0
var growth_complete = false

#Harvest animation
var AMPLITUDE = 1
var PERIOD = 0.5
var ANIMATION_REST_TIME = 0.75

var animation_rest_timer = 0
var original_pos_y
var delta_total = 0


func initialize(crop_def):
	if Cheats.CROP_GROWTH_TIME_OVERRIDE:
		stage_growth_duration = Cheats.CROP_GROWTH_TIME_OVERRIDE
	else:
		stage_growth_duration = crop_def["stage_growth_duration"]
	total_stages = crop_def["total_stages"]
	
	harvest_on_click = crop_def["harvest_on_click"]
	pick_on_click = crop_def["pick_on_click"]
	pick_stage_setback = crop_def["pick_stage_setback"]
	resources = crop_def["resources"]
	offset = crop_def["offset"]
	sprite_frames = load(crop_def["frames"])
	
func animate(delta):
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

func _process(delta: float) -> void:
	timer += delta
	if timer> stage_growth_duration and not growth_complete:
		grow()
	if growth_complete:
		animate(delta)
		
		
		#right half of sin wave every second
	
	
func grow():
	stage +=1 
	timer = 0
	if stage >= total_stages-1:
		growth_complete = true
		original_pos_y = position.y
	frame = stage
	

func pick():
	stage -= pick_stage_setback
	frame = stage
	growth_complete = false
	timer = 0
		
func get_harvestable():
	return (stage >= total_stages-1)
	
func harvest():
	if get_harvestable():
		if harvest_on_click:
			queue_free()
		else:
			pick()
		print("here are da resource: ", resources)
		return resources
	else:
		return false
