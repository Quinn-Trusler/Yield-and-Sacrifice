extends AnimatedSprite2D

#differ by plant
var stage_growth_duration = 4
var total_stages = 4

#change as plant grows
var stage = 0
var timer = 0
var growth_complete = false

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
