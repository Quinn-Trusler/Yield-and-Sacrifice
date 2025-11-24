extends AnimatedSprite2D

var BUILDING_TYPE = "fire"

#var pos = Vector2.ZERO
var timer = 0
var RNG = RandomNumberGenerator.new()
var BURN_TIME = 3 + RNG.randf_range(-100,100)/100
func _ready() -> void:
	play("default")
#func initialize(p):
	#pos = p
func _process(delta: float) -> void:
	timer += delta
	if timer> BURN_TIME:
		spread_fire()

func spread_fire():
	get_parent().spread_fire(get_meta("tile_coords"))
