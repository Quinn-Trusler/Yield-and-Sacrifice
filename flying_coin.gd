extends AnimatedSprite2D


var ending_pos : Vector2 = Vector2(-146.75, -62.5)
var starting_pos : Vector2
var delta_total : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_pos(pos : Vector2) -> void:
	position = pos
	starting_pos = pos
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta_total += delta
	position = lerp(starting_pos, ending_pos, delta_total*2)
	if delta_total*2 >= 1:
		queue_free()
	
	#Lerp it the collection loncation and then disapear
