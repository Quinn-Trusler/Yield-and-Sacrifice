extends Node2D


var FORWARD_SLASH_IMG = load("res://art/ui/forward_slash.png")
#@onready var Text = 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_round_number(round_number : int , total_rounds : int):
	$RoundText.clear()
	$RoundText.add_text(str(round_number))
	$RoundText.add_image(FORWARD_SLASH_IMG)
	$RoundText.add_text(str(total_rounds))
	
func update_round_number(round_number : int , total_rounds : int):
	set_round_number(round_number, total_rounds)
	$RoundText.animate()
