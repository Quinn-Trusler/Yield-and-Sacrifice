extends Node2D

@export var HBox : HBoxContainer
@export var CheckmarkImg : Texture2D
@export var ForwardSlashImg : Texture2D
@export var SacrificeTextLabel : PackedScene
@export var ItemButton : PackedScene

signal item_button_mouse_entered(pos : Vector2, item_name : String)
signal item_button_mouse_exited(pos : Vector2, item_name : String)
signal item_button_pressed(pos : Vector2, item_name : String)

const SPACING_AFTER_TEXT : String= " "


## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#update({"carrot":1, "wheat":2, "sugarcane":0},{"carrot":2, "wheat":9, "sugarcane" :1})
	#
	#

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
			number_text.append_text(SPACING_AFTER_TEXT)
		else:
			number_text.add_image(CheckmarkImg) 
			number_text.append_text(SPACING_AFTER_TEXT)
			
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

func add_image_button(item_name : String) -> void:
	var item_file_name = GLOBALCONSTS.OUTLINE_ITEMS_FOLDER + GLOBALCONSTS.ITEM_DEF[item_name]["img"]+"_outline"+GLOBALCONSTS.IMG_EXTENSION
	var item_button = ItemButton.instantiate()#TextureButton.new()
	item_button.set_item_name(item_name)
	item_button.set_v_size_flags(Control.SIZE_SHRINK_CENTER) # Centers button vertically within HBox container
	item_button.texture_normal = load(item_file_name)
	var image_size = Vector2(item_button.texture_normal.get_width(), item_button.texture_normal.get_height())
	item_button.set_custom_minimum_size(image_size) # seems to have no effect on the spacing of the text
	# TODO make sure text is closer to images
	
	HBox.add_child(item_button)
	item_buttons.append(item_button)
	
	item_button.item_button_mouse_entered.connect(_mouse_entered_button)
	item_button.item_button_mouse_exited.connect(_mouse_exited_button)
	item_button.item_button_pressed.connect(_pressed_button)


# Add way to detect hover
# Change text settings for rich text label -> probably remake something
func _mouse_entered_button(pos : Vector2, item_name : String):
	item_button_mouse_entered.emit(to_global(pos + HBox.position), item_name)


func _mouse_exited_button(pos : Vector2, item_name : String):
	item_button_mouse_exited.emit(to_global(pos + HBox.position), item_name)
	

func _pressed_button(pos : Vector2, item_name : String):
	item_button_pressed.emit(to_global(pos + HBox.position), item_name)

	
