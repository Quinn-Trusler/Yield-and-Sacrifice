extends AnimatedSprite2D

var BUILDING_TYPE : String = "fire"

#var pos = Vector2.ZERO
var timer = 0
var RNG = RandomNumberGenerator.new()
var STAGE_ZERO_TIME : float = 1 + RNG.randf_range(-100,100)/100
var STAGE_ONE_TIME : float = 1 + RNG.randf_range(-100,100)/100
var SPREAD_TIME : float = STAGE_ZERO_TIME + STAGE_ONE_TIME + RNG.randf_range(0,100)/100
var BURN_TIME : float = SPREAD_TIME +0.25+ RNG.randf_range(0,100)/100
var has_spread_fire : bool = false
var current_stage : int = 0
func _ready() -> void: 
	play("0")
#func initialize(p):
	#pos = p
func _process(delta: float) -> void:
	timer += delta
	
	if current_stage == 0 and timer > STAGE_ZERO_TIME:
		current_stage += 1
		play("1")
	elif current_stage == 1 and timer > STAGE_ONE_TIME + STAGE_ZERO_TIME:
		current_stage += 1
		play("2")
		
	if timer> SPREAD_TIME and not has_spread_fire:
		spread_fire()
		has_spread_fire = true
	if timer> BURN_TIME:
		finish_burn()
		

func spread_fire() -> void:
	get_parent().spread_fire(get_meta("tile_coords"))
	
func finish_burn() -> void:
	get_parent().finish_burn(get_meta("tile_coords"))
