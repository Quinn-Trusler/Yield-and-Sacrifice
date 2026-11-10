extends Node2D

@export var HBox : HBoxContainer
@export var CheckmarkImg : Texture2D
@export var ForwardSlashImg : Texture2D
@export var SacrificeTextLabel : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update({"carrot":1, "wheat":2},{"carrot":2, "wheat":9})
	pass # Replace with function body.

var item_buttons : Array = []
var text_scenes : Array = []


func update(filled_requirements : Dictionary,  requirements: Dictionary) -> void:
	erase()
	
	for item in requirements:
		var number_text = SacrificeTextLabel.instantiate()
		number_text.fit_content = true
		add_image_button(item)
		if filled_requirements[item] < requirements[item]:
			number_text.append_text(str(filled_requirements[item]))
			number_text.add_image(ForwardSlashImg)
			number_text.append_text(str(requirements[item]))
		else:
			number_text.add_image(CheckmarkImg) 
			
		print("Number text:", number_text.get_custom_minimum_size())
		HBox.add_child(number_text)
		text_scenes.append(number_text)
		
		

func erase():
	for item_button in item_buttons:
		item_button.queue_free()
	item_buttons = []
	for text in text_scenes:
		text.queue_free()
	text_scenes = []

func add_image_button(img_name : String) -> void:
	var item_file_name = GLOBALCONSTS.OUTLINE_ITEMS_FOLDER + GLOBALCONSTS.ITEM_DEF[img_name]["img"]+"_outline"+GLOBALCONSTS.IMG_EXTENSION
	var image_button = TextureButton.new()
	image_button.set_v_size_flags(Control.SIZE_SHRINK_CENTER) # Centers button vertically within HBox container
	image_button.texture_normal = load(item_file_name)
	var image_size = Vector2(image_button.texture_normal.get_width(), image_button.texture_normal.get_height())
	image_button.set_custom_minimum_size(image_size) # seems to have no effect on the spacing of the text
	# TODO make sure text is closer to images
	
	HBox.add_child(image_button)
	item_buttons.append(image_button)
	
# Add way to detect hover
# Change text settings for rich text label -> probably remake something
	
