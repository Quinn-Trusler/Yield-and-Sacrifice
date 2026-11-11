extends VBoxContainer

@export var BgTop : TextureRect
@export var BgMiddle : TextureRect
@export var BgBottom : TextureRect
@export var HeightPadding : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func set_height(height : int) -> void:
	var middle_height = height - (BgTop.get_size().y + BgBottom.get_size().y) + HeightPadding*2
	var region = Rect2i(0,0,BgMiddle.get_size().x, middle_height)
	BgMiddle.texture.set_region(region)
