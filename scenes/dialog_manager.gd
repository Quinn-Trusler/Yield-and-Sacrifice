extends CanvasLayer



var border_size : int = 1
var dialog : String = "Testing purposes"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_border_rect()
	set_dialog("This is a test")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_dialog(new_dialog : String) -> void:
	dialog = new_dialog
	display_dialog()

func display_dialog() -> void:
	$Control/Dialog.text = dialog

func set_colour(border : Color,inner_rect : Color,text : Color) -> void:
	pass

func set_border_rect() -> void:
	$Control/BorderRect.position = $Control/InnerRect.position - Vector2(border_size,border_size)*4 
	$Control/BorderRect.size = $Control/InnerRect.size + Vector2(2*border_size, 2*border_size)
	#print($Control/BorderRect.position, $Control/InnerRect.position)
	#print($Control/BorderRect.size, $Control/InnerRect.size)
