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

func initialize(crop_def):
	stage_growth_duration = crop_def["stage_growth_duration"]
	total_stages = crop_def["total_stages"]
	
	harvest_on_click = crop_def["harvest_on_click"]
	pick_on_click = crop_def["pick_on_click"]
	pick_stage_setback = crop_def["pick_stage_setback"]
	resources = crop_def["resources"]
	offset = crop_def["offset"]
	sprite_frames = load(crop_def["frames"])
	

func _process(delta: float) -> void:
	timer += delta
	if timer> stage_growth_duration and not growth_complete:
		grow()
	
	
func grow():
	stage +=1 
	timer = 0
	if stage >= total_stages-1:
		growth_complete = true
	frame = stage
	
func pick():
	if stage >= total_stages -1 - (pick_on_click-1) * pick_stage_setback:
		stage -= pick_stage_setback
		frame = stage
	else:
		return false
	
	
func harvest():
	if stage >= total_stages-1:
		queue_free()
		return resources
	else:
		return false
