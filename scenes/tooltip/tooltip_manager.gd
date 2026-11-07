extends Node2D

@onready var tooltip_scene = load("res://scenes/tooltip/tooltip.tscn")

var tooltip = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func create_tooltip(pos : Vector2, tooltip_name : String, tooltip_type : GLOBALCONSTS.TOOLTIP_TYPES) -> void:
	if tooltip:
		tooltip.queue_free()
	tooltip = tooltip_scene.instantiate()
	add_child(tooltip)
	tooltip.setup_tooltip(tooltip_name, tooltip_type)
	tooltip.position = pos
	tooltip.print_all()
	
	
